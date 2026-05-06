import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapptechnicaltest/model/ayahsModel.dart';

class AyahController extends GetxController {
  var ayahList = <Ayah>[].obs;
  var isLoading = true.obs;

  Future<void> fetchAyahs(int surahNumber, {String qori = 'ar.alafasy'}) async {
    try {
      isLoading(true);
      ayahList.clear();

      // Hit API secara paralel untuk efisiensi
      final responses = await Future.wait([
        http.get(
          Uri.parse(
            'https://api.alquran.cloud/v1/surah/$surahNumber/$qori',
          ),
        ),
        http.get(
          Uri.parse('https://api.alquran.cloud/v1/surah/$surahNumber/en.asad'),
        ),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final arabicData =
            json.decode(responses[0].body)['data']['ayahs'] as List;
        final translationData =
            json.decode(responses[1].body)['data']['ayahs'] as List;

        List<Ayah> mergedList = [];
        for (int i = 0; i < arabicData.length; i++) {
          mergedList.add(
            Ayah(
              text: arabicData[i]['text'],
              audio: arabicData[i]['audio'],
              translation: translationData[i]['text'],
            ),
          );
        }
        ayahList.value = mergedList;
      }
    } catch (e) {
      print("Error fetching ayahs: $e");
    } finally {
      isLoading(false);
    }
  }
}
