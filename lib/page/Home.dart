import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileapptechnicaltest/component/listSurah.dart';
import 'package:mobileapptechnicaltest/tools/colors.dart';
import 'package:mobileapptechnicaltest/view model/audio.dart';
import 'package:mobileapptechnicaltest/view model/qori.dart';
import 'package:mobileapptechnicaltest/view model/surah.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final SurahController controller = Get.put(SurahController());
  final QoriController qoriController = Get.put(QoriController());
  final AudioController audioController = Get.find<AudioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 10),
        title: Text("AL-Quran", style: TextStyle(color: AppColors.darkGreen)),
        centerTitle: true,
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          onPressed: () => _showQoriSelectionSheet(context),
          icon: Icon(Icons.person_search_rounded, color: AppColors.darkGreen),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed("/search"),
            icon: Icon(Icons.search, color: AppColors.darkGreen),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
          itemBuilder: (context, index) {
            final surah = controller.surahList[index];
            return listSurah(index + 1, surah);
          },
          itemCount: controller.surahList.length,
        );
      }),
    );
  }

  void _showQoriSelectionSheet(BuildContext context) {
    qoriController.resetSearch(); // Reset list saat dibuka
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Pilih Qori (Reciter)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 20),
            // Search Bar
            TextField(
              onChanged: (value) => qoriController.searchQori(value),
              decoration: InputDecoration(
                hintText: "Cari nama Qori...",
                hintStyle: TextStyle(color: AppColors.darkGreen),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.darkGreen,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 15),
            // Current Selected
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.gold,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Dipilih: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        audioController.selectedQoriName.value,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // List of Qoris
            Expanded(
              child: Obx(() {
                if (qoriController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: qoriController.filteredQoriList.length,
                  itemBuilder: (context, index) {
                    final qori = qoriController.filteredQoriList[index];
                    return ListTile(
                      title: Text(
                        qori.englishName,
                        style: const TextStyle(color: AppColors.black),
                      ),
                      subtitle: Text(
                        qori.identifier,
                        style: const TextStyle(fontSize: 10),
                      ),
                      onTap: () {
                        audioController.selectedQori.value = qori.identifier;
                        audioController.selectedQoriName.value =
                            qori.englishName;
                        qoriController
                            .resetSearch(); // Reset list setelah pilih
                        Get.back();
                        Get.snackbar(
                          "Qori Diubah",
                          "Sekarang memutar suara ${qori.englishName}. Memutar ulang playlist untuk menyesuaikan suara qori.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: AppColors.darkTeal,
                          colorText: Colors.white,
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
