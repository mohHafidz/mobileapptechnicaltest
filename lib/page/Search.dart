import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobileapptechnicaltest/component/listSurah.dart';
import 'package:mobileapptechnicaltest/tools/colors.dart';
import 'package:mobileapptechnicaltest/view model/surah.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final SurahController controller = Get.find<SurahController>();

  @override
  void initState() {
    super.initState();
    // Auto focus saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }


  bool isSubmitted = false;
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGreen),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (value.trim().isEmpty) return;
            controller.addRecentSearch(value);
            setState(() {
              isSubmitted = true;
              query = value;
            });
          },
          decoration: const InputDecoration(
            hintText: "Search Surah...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: AppColors.darkGreen, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isSubmitted
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Search result for \"$query\"",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: controller.surahList
                          .where(
                            (s) => s.englishName.toLowerCase().contains(
                              query.toLowerCase(),
                            ),
                          )
                          .length,
                      itemBuilder: (context, index) {
                        final filteredList = controller.surahList
                            .where(
                              (s) => s.englishName.toLowerCase().contains(
                                query.toLowerCase(),
                              ),
                            )
                            .toList();
                        return listSurah(index + 1, filteredList[index]);
                      },
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recent Search",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Obx(
                    () => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.recentSearches.map((search) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _searchController.text = search;
                              query = search;
                              isSubmitted = true;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mint,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.darkTeal.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.history,
                                  size: 16,
                                  color: AppColors.darkTeal,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  search,
                                  style:
                                      const TextStyle(color: AppColors.darkTeal),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
