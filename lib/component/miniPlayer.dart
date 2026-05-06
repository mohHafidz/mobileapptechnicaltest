import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileapptechnicaltest/tools/colors.dart';
import 'package:mobileapptechnicaltest/view model/audio.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioController controller = Get.find<AudioController>();

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () => Get.toNamed("/nowPlaying"),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              children: [
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(
                    () => Row(
                      children: [
                        // Album Art
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/image/Background Texture.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Info
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.currentSurah.value?.englishName ??
                                    "Unknown",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Ayah ${controller.currentAyahIndex.value + 1} - ${controller.selectedQoriName.value}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Controls
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous_rounded),
                              color: Colors.white,
                              iconSize: 28,
                              onPressed: () => controller.previous(),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => controller.playPause(),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.gold,
                                ),
                                child: Icon(
                                  controller.isPlaying.value
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: AppColors.darkGreen,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.skip_next_rounded),
                              color: Colors.white,
                              iconSize: 28,
                              onPressed: () => controller.isShuffle.value
                                  ? controller.playRandomSurah()
                                  : controller.playNextSurah(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Progress "Border" (At the bottom)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: StreamBuilder<Duration>(
                    stream: controller.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration?>(
                        stream: controller.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data ?? Duration.zero;
                          double progress = 0.0;
                          if (duration.inMilliseconds > 0) {
                            progress =
                                position.inMilliseconds /
                                duration.inMilliseconds;
                          }
                          return Container(
                            height: 3,
                            color: Colors.white.withOpacity(0.1),
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: progress.clamp(0.0, 1.0),
                              child: Container(
                                height: 3,
                                color: AppColors.gold,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
