import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileapptechnicaltest/model/surahModel.dart';
import 'package:mobileapptechnicaltest/tools/colors.dart';
import 'package:mobileapptechnicaltest/component/number.dart';
import 'package:mobileapptechnicaltest/view model/audio.dart';
import 'package:mobileapptechnicaltest/view model/ayah.dart';

class DetailSurah extends StatefulWidget {
  const DetailSurah({Key? key}) : super(key: key);

  @override
  State<DetailSurah> createState() => _DetailSurahState();
}

class _DetailSurahState extends State<DetailSurah> {
  final AyahController controller = Get.put(AyahController());
  final AudioController audioController = Get.find<AudioController>();
  final Map<int, GlobalKey> _ayahKeys = {};
  late Rx<Surah> currentDisplaySurah;

  @override
  void initState() {
    super.initState();
    final Surah surah = Get.arguments;
    currentDisplaySurah = surah.obs;

    controller.fetchAyahs(
      surah.number,
      qori: audioController.selectedQori.value,
    );

    // Listener: Jika surah yang diputar berubah, maka halaman detail juga ikut berubah
    ever(audioController.currentSurah, (Surah? playingSurah) {
      if (playingSurah != null &&
          playingSurah.number != currentDisplaySurah.value.number) {
        currentDisplaySurah.value = playingSurah;
      }
    });

    // Listener untuk auto-scroll saat ayat berubah
    ever(audioController.currentAyahIndex, (index) {
      if (audioController.currentSurah.value?.number ==
          currentDisplaySurah.value.number) {
        _scrollToAyah(index);
      }
    });
  }

  void _scrollToAyah(int index) {
    final key = _ayahKeys[index];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.3, // Scroll agar ayat berada sedikit di atas tengah
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            currentDisplaySurah.value.englishName,
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGreen),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // Header Info Surah
            SliverToBoxAdapter(
              child: Obx(() {
                final surah = currentDisplaySurah.value;
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [AppColors.darkGreen, AppColors.darkTeal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    image: const DecorationImage(
                      image: AssetImage("assets/image/Background Texture.png"),
                      fit: BoxFit.cover,
                      opacity: 0.1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            surah.englishName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            surah.englishNameTranslation,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${surah.revelationType} • ",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "${surah.numberOfAyahs} Ayat",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (controller.ayahList.isNotEmpty) {
                            audioController.playSurah(
                              surah,
                              controller.ayahList,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.gold,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: AppColors.darkGreen,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            // Daftar Ayat
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final ayah = controller.ayahList[index];
                  _ayahKeys[index] = GlobalKey();

                  return Obx(() {
                    // Cek apakah ayat ini sedang di-play
                    bool isPlaying =
                        audioController.currentSurah.value?.number ==
                            currentDisplaySurah.value.number &&
                        audioController.currentAyahIndex.value == index;

                    return Container(
                      key: _ayahKeys[index],
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isPlaying
                            ? AppColors.gold.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: isPlaying
                            ? Border.all(color: AppColors.gold, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NumberAyah(index + 1),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  ayah.text,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: AppColors.darkTeal,
                                    height: 1.8,
                                    fontFamily: GoogleFonts.amiri().fontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            ayah.translation,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.black,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                }, childCount: controller.ayahList.length),
              ),
            ),
            // Spacer untuk MiniPlayer
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        );
      }),
    );
  }
}
