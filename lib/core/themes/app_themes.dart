import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:namastethailand/core/constants/my_colors.dart';

class AppThemes{

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: MyColors.appColor),
    useMaterial3: true,
    fontFamily: GoogleFonts.adamina(letterSpacing: 1,wordSpacing: 2).fontFamily
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: MyColors.dark),
    useMaterial3: true
  );
}