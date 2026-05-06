import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileapptechnicaltest/tools/colors.dart';
import 'package:mobileapptechnicaltest/view model/audio.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({Key? key}) : super(key: key);

  String _formatDuration(Duration? duration) {
    if (duration == null) return "00:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final AudioController audioController = Get.find<AudioController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Now Playing",
          style: TextStyle(
            color: AppColors.darkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.darkGreen,
            size: 32,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final surah = audioController.currentSurah.value;
        if (surah == null) {
          return Center(child: Text("No surah playing"));
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(24),
                  height: 320,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                      colors: [AppColors.darkGreen, AppColors.darkTeal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    image: DecorationImage(
                      image: AssetImage("assets/image/Background Texture.png"),
                      fit: BoxFit.cover,
                      opacity: 0.15,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        surah.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 48,
                          fontFamily: GoogleFonts.amiri().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Surah ${surah.englishName}",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        surah.englishNameTranslation,
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Progress Bar and Time
                StreamBuilder<Duration>(
                  stream: audioController.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                      stream: audioController.durationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        final progress = duration.inMilliseconds > 0
                            ? position.inMilliseconds / duration.inMilliseconds
                            : 0.0;

                        return Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 8,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFE4E3D7),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: progress.clamp(0.0, 1.0),
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.gold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 10),
                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.loop, color: AppColors.black, size: 24),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.skip_previous,
                        color: AppColors.darkGreen,
                        size: 40,
                      ),
                      onPressed: () => audioController.previous(),
                    ),
                    InkWell(
                      onTap: () => audioController.playPause(),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.darkTeal,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkTeal.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          audioController.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: AppColors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: AppColors.darkGreen,
                        size: 40,
                      ),
                      onPressed: () => audioController.next(),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: audioController.isShuffle.value
                            ? AppColors.gold
                            : AppColors.black,
                        size: 24,
                      ),
                      onPressed: () => audioController.setshuffle(),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Current Ayah Info
                if (audioController.ayahList.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.darkGreen.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Ayat ${audioController.currentAyahIndex.value + 1}",
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          audioController
                              .ayahList[audioController.currentAyahIndex.value]
                              .text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.darkTeal,
                            fontFamily: GoogleFonts.amiri().fontFamily,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          audioController
                              .ayahList[audioController.currentAyahIndex.value]
                              .translation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }
}
