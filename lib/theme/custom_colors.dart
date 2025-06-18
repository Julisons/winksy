import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color xPrimaryColor;
  final Color xTextColor;
  final Color xTextColorSecondary;
  final Color xTrailing;
  final Color xTrailingAlt;
  final Color xTextColorTertiary;
  final Color xSecondaryColor;
  final Color xSecondaryColorSelected;

  const CustomColors({
    required this.xPrimaryColor,
    required this.xTextColor,
    required this.xTextColorSecondary,
    required this.xTrailing,
    required this.xTrailingAlt,
    required this.xTextColorTertiary,
    required this.xSecondaryColor,
    required this.xSecondaryColorSelected,
  });

  @override
  CustomColors copyWith({
    Color? xPrimaryColor,
    Color? xTextColor,
    Color? xTextColorSecondary,
    Color? xTrailing,
    Color? xTextColorTertiary,
    Color? xSecondaryColor,
    Color? xSecondaryColorSelected,
  }) {
    return CustomColors(
      xPrimaryColor: xPrimaryColor ?? this.xPrimaryColor,
      xTextColor: xTextColor ?? this.xTextColor,
      xTextColorSecondary: xTextColorSecondary ?? this.xTextColorSecondary,
      xTrailing: xTrailing ?? this.xTrailing,
      xTrailingAlt: xTrailingAlt ?? this.xTrailingAlt,
      xTextColorTertiary: xTextColorTertiary ?? this.xTextColorTertiary,
      xSecondaryColor: xSecondaryColor ?? this.xSecondaryColor,
      xSecondaryColorSelected: xSecondaryColorSelected ?? this.xSecondaryColorSelected,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      xPrimaryColor: Color.lerp(xPrimaryColor, other.xPrimaryColor, t)!,
      xTextColor: Color.lerp(xTextColor, other.xTextColor, t)!,
      xTextColorSecondary: Color.lerp(xTextColorSecondary, other.xTextColorSecondary, t)!,
      xTrailing: Color.lerp(xTrailing, other.xTrailing, t)!,
      xTrailingAlt: xTrailingAlt ?? this.xTrailingAlt,
      xTextColorTertiary: Color.lerp(xTextColorTertiary, other.xTextColorTertiary, t)!,
      xSecondaryColor: Color.lerp(xSecondaryColor, other.xSecondaryColor, t)!,
      xSecondaryColorSelected: Color.lerp(xSecondaryColorSelected, other.xSecondaryColorSelected, t)!,
    );
  }
}
