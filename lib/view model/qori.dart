import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapptechnicaltest/model/qoriModel.dart';

class QoriController extends GetxController {
  var qoriList = <QoriModel>[].obs;
  var filteredQoriList = <QoriModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchQoris();
    super.onInit();
  }

  Future<void> fetchQoris() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('https://api.alquran.cloud/v1/edition/format/audio'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var data = jsonData['data'] as List;
        
        // Filter: Kita hanya ambil yang format audio dan tipe 'versebyverse' 
        // agar kompatibel dengan sistem playlist kita saat ini.
        // Tapi permintaan user adalah ambil seluruhnya dari API tersebut.
        // Kita ikuti permintaan user untuk ambil seluruhnya.
        
        var list = data.map((qori) => QoriModel.fromJson(qori)).toList();
        qoriList.value = list;
        filteredQoriList.value = list;
      }
    } catch (e) {
      print("Error fetching qoris: $e");
    } finally {
      isLoading(false);
    }
  }

  void searchQori(String query) {
    if (query.isEmpty) {
      resetSearch();
    } else {
      filteredQoriList.value = qoriList
          .where((qori) => qori.englishName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void resetSearch() {
    filteredQoriList.value = qoriList;
  }
}
