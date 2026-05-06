import 'package:flutter/material.dart';
import 'package:mobileapptechnicaltest/tools/colors.dart';

Widget NumberAyah(int number) {
  return Stack(
    alignment: Alignment.center,
    children: [
      // Bintang Gold (Luar)
      Transform.rotate(
        angle: 45 * 3.14159265 / 180,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      // Bagian Putih (Dalam) untuk membuat efek border
      Transform.rotate(
        angle: 45 * 3.14159265 / 180,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
      Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      // Nomor Ayat
      Text(
        "$number",
        style: TextStyle(
          color: AppColors.darkGreen,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ],
  );
}
