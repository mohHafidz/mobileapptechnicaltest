import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileapptechnicaltest/model/surahModel.dart';
import 'package:mobileapptechnicaltest/tools/colors.dart';
import 'package:mobileapptechnicaltest/component/number.dart';

Widget listSurah(int no, Surah surah) {
  return InkWell(
    onTap: () => Get.toNamed("/detailSurah", arguments: surah),
    child: Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xf064E3B),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        // mainAxisAlignment: main,
        children: [
          NumberAyah(no),
          SizedBox(width: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${surah.englishName}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
              Text(
                "${surah.numberOfAyahs} Ayat",
                style: TextStyle(fontSize: 12, color: AppColors.black),
              ),
            ],
          ),

          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${surah.name}",
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.darkTeal,
                  fontFamily: GoogleFonts.amiri().fontFamily,
                ),
              ),
              Text("${surah.englishNameTranslation}"),
            ],
          ),
        ],
      ),
    ),
  );
}
