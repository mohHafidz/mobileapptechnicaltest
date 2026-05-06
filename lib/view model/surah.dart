import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapptechnicaltest/model/surahModel.dart';

class SurahController extends GetxController {
  var surahList = <Surah>[].obs;
  var isLoading = true.obs;
  var recentSearches = <String>[].obs;

  @override
  void onInit() {
    fetchSurahs();
    super.onInit();
  }

  void fetchSurahs() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('http://api.alquran.cloud/v1/surah'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var data = jsonData['data'] as List;
        surahList.value = data.map((surah) => Surah.fromJson(surah)).toList();
      }
    } catch (e) {
      print("Error fetching surahs: $e");
    } finally {
      isLoading(false);
    }
  }

  void addRecentSearch(String search) {
    if (search.trim().isEmpty) return;
    recentSearches.removeWhere(
      (element) => element.toLowerCase() == search.trim().toLowerCase(),
    );
    recentSearches.insert(0, search.trim());
    if (recentSearches.length > 6) {
      recentSearches.removeLast();
    }
  }
}
