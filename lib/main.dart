import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileapptechnicaltest/component/miniPlayer.dart';
import 'package:mobileapptechnicaltest/page/DetailSurah.dart';
import 'package:mobileapptechnicaltest/page/Home.dart';
import 'package:mobileapptechnicaltest/page/Search.dart';
import 'package:mobileapptechnicaltest/page/nowPlaying.dart';
import 'package:mobileapptechnicaltest/tools/colors.dart';
import 'package:mobileapptechnicaltest/view model/audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

// Variabel global untuk tracking route
final RxString currentRoute = ''.obs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Inisialisasi AudioController secara global
    final AudioController audioController = Get.put(AudioController());

    return GetMaterialApp(
      routingCallback: (routing) {
        if (routing != null) {
          currentRoute.value = routing.current;
        }
      },
      getPages: [
        GetPage(name: "/home", page: () => Home()),
        GetPage(
          name: "/nowPlaying",
          page: () => NowPlaying(),
          transition: Transition.downToUp,
          transitionDuration: Duration(milliseconds: 300),
        ),
        GetPage(
          name: "/search",
          page: () => const SearchPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: "/detailSurah",
          page: () => const DetailSurah(),
          transition: Transition.rightToLeft,
        ),
      ],
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.darkTeal,
          onPrimary: Colors.white,
          secondary: AppColors.gold,
          onSecondary: Colors.black,
          surface: AppColors.darkGreen,
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.white,
        ),
        textTheme: GoogleFonts.manropeTextTheme(),
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            Obx(() {
              // Sembunyikan mini player jika sedang di halaman nowPlaying
              // atau tidak ada audio yang di-load
              if (currentRoute.value == '/nowPlaying' ||
                  !audioController.hasAudio.value) {
                return const SizedBox.shrink();
              }
              return const Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: MiniPlayer(),
              );
            }),
          ],
        );
      },
      home: Home(),
    );
  }
}
