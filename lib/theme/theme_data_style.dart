import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../mixin/constants.dart';
import 'custom_colors.dart';

class ThemeDataStyle {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: GoogleFonts.quicksandTextTheme(), // Set globally
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      primary: Colors.white,
      secondary: HexColor.fromHex('#f21c1b'),
      tertiary: HexColor.fromHex('#f21c1b'),
      surfaceTint: Colors.white,
    ),
  );

  static final ThemeData darker = dark.copyWith(
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        xPrimaryColor: Colors.black,
        xTextColor: Colors.white54,
        xTextColorSecondary:  Colors.white,
        xTrailing: HexColor.fromHex('#f21c1b'),
        xTrailingAlt:HexColor.fromHex('#007fff'),
        xTextColorTertiary: Colors.grey,
        xSecondaryColor: Color.fromARGB(255, 17, 17, 17),
        xSecondaryColorSelected: Colors.white30,
      ),
    ],
  );

  static final ThemeData lighter = light.copyWith(
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        xPrimaryColor: Colors.white,
        xTextColor: Colors.black54,
        xTextColorSecondary: Colors.black,
        xTrailing: HexColor.fromHex('#f21c1b'),
        xTrailingAlt: HexColor.fromHex('#007fff'),
        xTextColorTertiary: Colors.grey,
        xSecondaryColor: Color.fromARGB(255, 240, 240, 240),
        xSecondaryColorSelected: Colors.black26,
      ),
    ],
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.quicksandTextTheme(), // Set globally
    colorScheme: ColorScheme.dark(
      surface: Colors.black,
      primary: HexColor.fromHex('#666666'),
      secondary: HexColor.fromHex('#333333'),
      tertiary: HexColor.fromHex('#f21c1b'),
      surfaceTint: Colors.white,
    ),
  );
}
