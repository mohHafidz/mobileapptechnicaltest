import 'dart:math';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mobileapptechnicaltest/model/ayahsModel.dart';
import 'package:mobileapptechnicaltest/model/surahModel.dart';
import 'package:mobileapptechnicaltest/view%20model/ayah.dart';
import 'package:mobileapptechnicaltest/view%20model/surah.dart';

class AudioController extends GetxController {
  final AudioPlayer _player = AudioPlayer();
  final SurahController surah = Get.put(SurahController());
  final AyahController ayahs = Get.put(AyahController());

  var selectedQori = 'ar.alafasy'.obs;
  var selectedQoriName = 'Mishary Rashid Alafasy'.obs;

  var isShuffle = false.obs;

  var currentSurah = Rxn<Surah>();
  var currentAyahIndex = 0.obs;
  var isPlaying = false.obs;
  var hasAudio = false.obs;
  var ayahList = <Ayah>[].obs;
  final List<Surah> _surahHistory = [];

  @override
  void onInit() {
    super.onInit();

    // Monitor status playback
    _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;

      if (state.processingState == ProcessingState.completed) {
        // Logika jika playlist selesai bisa ditambahkan di sini
        playShuffle();
      }
    });

    // Monitor index ayat yang sedang diputar
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        currentAyahIndex.value = index;
      }
    });
  }

  void setshuffle() {
    isShuffle.toggle();
  }

  void playShuffle() {
    if (isShuffle.value == true) {
      playRandomSurah();
    } else {
      playNextSurah();
    }
  }

  void playNextSurah() async {
    if (currentSurah.value == null || surah.surahList.isEmpty) return;

    // Cari index surah saat ini
    int currentIndex = surah.surahList.indexWhere(
      (s) => s.number == currentSurah.value!.number,
    );

    // Tentukan index surah berikutnya (loop ke awal jika sudah di akhir)
    int nextIndex = (currentIndex + 1) % surah.surahList.length;
    final nextSurah = surah.surahList[nextIndex];

    // Ambil ayat surah berikutnya dan putar
    await ayahs.fetchAyahs(nextSurah.number, qori: selectedQori.value);
    playSurah(nextSurah, ayahs.ayahList);
  }

  void playPreviousSurah() async {
    if (currentSurah.value == null || surah.surahList.isEmpty) return;

    if (_surahHistory.isNotEmpty) {
      final prevSurah = _surahHistory.removeLast();
      await ayahs.fetchAyahs(prevSurah.number, qori: selectedQori.value);
      playSurah(prevSurah, ayahs.ayahList, isFromHistory: true);
      return;
    }

    // Cari index surah saat ini jika history kosong
    int currentIndex = surah.surahList.indexWhere(
      (s) => s.number == currentSurah.value!.number,
    );

    // Tentukan index surah sebelumnya (loop ke akhir jika sudah di awal)
    int prevIndex =
        (currentIndex - 1 + surah.surahList.length) % surah.surahList.length;
    final prevSurah = surah.surahList[prevIndex];

    // Ambil ayat surah sebelumnya dan putar
    await ayahs.fetchAyahs(prevSurah.number, qori: selectedQori.value);
    playSurah(prevSurah, ayahs.ayahList);
  }

  void playRandomSurah() async {
    final random = Random();

    if (surah.surahList.isEmpty) return; // Keamanan jika list kosong

    final randomSurahIndex = random.nextInt(surah.surahList.length);
    final randomSurah = surah.surahList[randomSurahIndex];
    await ayahs.fetchAyahs(randomSurah.number, qori: selectedQori.value);
    playSurah(randomSurah, ayahs.ayahList);
  }

  Future<void> playSurah(
    Surah surah,
    List<Ayah> ayahs, {
    bool isFromHistory = false,
  }) async {
    try {
      if (!isFromHistory && currentSurah.value != null) {
        // Simpan surah saat ini ke history sebelum pindah ke surah baru
        if (_surahHistory.isEmpty ||
            _surahHistory.last.number != currentSurah.value!.number) {
          _surahHistory.add(currentSurah.value!);
        }
      }

      currentSurah.value = surah;
      ayahList.value = ayahs;

      hasAudio.value = true;

      // Buat playlist dari list ayat
      final playlist = ConcatenatingAudioSource(
        children: ayahs.asMap().entries.map((entry) {
          int index = entry.key;
          Ayah ayah = entry.value;
          return AudioSource.uri(
            Uri.parse(ayah.audio),
            tag: MediaItem(
              id: '${surah.number}_${index + 1}',
              album: surah.name,
              title: "Ayat ${index + 1}",
              artist: selectedQoriName.value,
              // artUri: Uri.parse(
              //   "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Quran_logo.svg/1024px-Quran_logo.svg.png",
              // ), // Placeholder or actual image
            ),
          );
        }).toList(),
      );

      await _player.setAudioSource(playlist);
      _player.play();
    } catch (e) {
      print("Error playing surah: $e");
    }
  }

  void playPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void stop() {
    _player.stop();
    hasAudio.value = false;
  }

  void next() {
    if (_player.hasNext) {
      _player.seekToNext();
    } else {
      playShuffle();
    }
  }

  void previous() {
    if (_player.currentIndex != null && _player.currentIndex! > 0) {
      _player.seekToPrevious();
    } else {
      playPreviousSurah();
    }
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }

  // Progress stream untuk UI
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  void seek(Duration position) {
    _player.seek(position);
  }
}
