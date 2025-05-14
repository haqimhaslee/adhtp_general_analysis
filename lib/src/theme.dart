import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006024),
      surfaceTint: Color(0xff006e2b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff087b32),
      onPrimaryContainer: Color(0xffabffb2),
      secondary: Color(0xff436745),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc1eac0),
      onSecondaryContainer: Color(0xff476b49),
      tertiary: Color(0xff124dad),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3666c7),
      onTertiaryContainer: Color(0xffe6ebff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff6fbf1),
      onSurface: Color(0xff171d17),
      onSurfaceVariant: Color(0xff3f4a3e),
      outline: Color(0xff6f7a6d),
      outlineVariant: Color(0xffbecabb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322b),
      inversePrimary: Color(0xff78dc86),
      primaryFixed: Color(0xff94f99f),
      onPrimaryFixed: Color(0xff002108),
      primaryFixedDim: Color(0xff78dc86),
      onPrimaryFixedVariant: Color(0xff00531e),
      secondaryFixed: Color(0xffc4edc2),
      onSecondaryFixed: Color(0xff002108),
      secondaryFixedDim: Color(0xffa8d1a8),
      onSecondaryFixedVariant: Color(0xff2b4e2f),
      tertiaryFixed: Color(0xffd9e2ff),
      onTertiaryFixed: Color(0xff001945),
      tertiaryFixedDim: Color(0xffb0c6ff),
      onTertiaryFixedVariant: Color(0xff00419d),
      surfaceDim: Color(0xffd6dcd2),
      surfaceBright: Color(0xfff6fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5eb),
      surfaceContainer: Color(0xffeaf0e5),
      surfaceContainerHigh: Color(0xffe4eae0),
      surfaceContainerHighest: Color(0xffdfe4da),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004016),
      surfaceTint: Color(0xff006e2b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff087b32),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1a3d20),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff517653),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00327b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3666c7),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf1),
      onSurface: Color(0xff0d130d),
      onSurfaceVariant: Color(0xff2e392e),
      outline: Color(0xff4a5549),
      outlineVariant: Color(0xff657063),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322b),
      inversePrimary: Color(0xff78dc86),
      primaryFixed: Color(0xff0f7e35),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff006326),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff517653),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff395d3c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff3a69ca),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff1750b0),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc2c8bf),
      surfaceBright: Color(0xfff6fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f5eb),
      surfaceContainer: Color(0xffe4eae0),
      surfaceContainerHigh: Color(0xffd9dfd5),
      surfaceContainerHighest: Color(0xffced3ca),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003410),
      surfaceTint: Color(0xff006e2b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00551f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff0f3316),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff2e5131),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002867),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff0044a1),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf1),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff252f24),
      outlineVariant: Color(0xff414c40),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c322b),
      inversePrimary: Color(0xff78dc86),
      primaryFixed: Color(0xff00551f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003c14),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff2e5131),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff173a1c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff0044a1),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff002f74),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb5bab1),
      surfaceBright: Color(0xfff6fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf2e8),
      surfaceContainer: Color(0xffdfe4da),
      surfaceContainerHigh: Color(0xffd0d6cc),
      surfaceContainerHighest: Color(0xffc2c8bf),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff78dc86),
      surfaceTint: Color(0xff78dc86),
      onPrimary: Color(0xff003913),
      primaryContainer: Color(0xff087b32),
      onPrimaryContainer: Color(0xffabffb2),
      secondary: Color(0xffa8d1a8),
      onSecondary: Color(0xff14371a),
      secondaryContainer: Color(0xff2e5131),
      onSecondaryContainer: Color(0xff9bc29a),
      tertiary: Color(0xffb0c6ff),
      onTertiary: Color(0xff002c6f),
      tertiaryContainer: Color(0xff3666c7),
      onTertiaryContainer: Color(0xffe6ebff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f150f),
      onSurface: Color(0xffdfe4da),
      onSurfaceVariant: Color(0xffbecabb),
      outline: Color(0xff889486),
      outlineVariant: Color(0xff3f4a3e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4da),
      inversePrimary: Color(0xff006e2b),
      primaryFixed: Color(0xff94f99f),
      onPrimaryFixed: Color(0xff002108),
      primaryFixedDim: Color(0xff78dc86),
      onPrimaryFixedVariant: Color(0xff00531e),
      secondaryFixed: Color(0xffc4edc2),
      onSecondaryFixed: Color(0xff002108),
      secondaryFixedDim: Color(0xffa8d1a8),
      onSecondaryFixedVariant: Color(0xff2b4e2f),
      tertiaryFixed: Color(0xffd9e2ff),
      onTertiaryFixed: Color(0xff001945),
      tertiaryFixedDim: Color(0xffb0c6ff),
      onTertiaryFixedVariant: Color(0xff00419d),
      surfaceDim: Color(0xff0f150f),
      surfaceBright: Color(0xff353b34),
      surfaceContainerLowest: Color(0xff0a100a),
      surfaceContainerLow: Color(0xff171d17),
      surfaceContainer: Color(0xff1b211b),
      surfaceContainerHigh: Color(0xff262b25),
      surfaceContainerHighest: Color(0xff313630),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff8ef29a),
      surfaceTint: Color(0xff78dc86),
      onPrimary: Color(0xff002d0d),
      primaryContainer: Color(0xff41a355),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbee7bd),
      onSecondary: Color(0xff082c10),
      secondaryContainer: Color(0xff749a75),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffd1dcff),
      onTertiary: Color(0xff00225a),
      tertiaryContainer: Color(0xff618ef1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f150f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4e0d0),
      outline: Color(0xffaab5a6),
      outlineVariant: Color(0xff889386),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4da),
      inversePrimary: Color(0xff00541f),
      primaryFixed: Color(0xff94f99f),
      onPrimaryFixed: Color(0xff001504),
      primaryFixedDim: Color(0xff78dc86),
      onPrimaryFixedVariant: Color(0xff004016),
      secondaryFixed: Color(0xffc4edc2),
      onSecondaryFixed: Color(0xff001504),
      secondaryFixedDim: Color(0xffa8d1a8),
      onSecondaryFixedVariant: Color(0xff1a3d20),
      tertiaryFixed: Color(0xffd9e2ff),
      onTertiaryFixed: Color(0xff000f31),
      tertiaryFixedDim: Color(0xffb0c6ff),
      onTertiaryFixedVariant: Color(0xff00327b),
      surfaceDim: Color(0xff0f150f),
      surfaceBright: Color(0xff40463f),
      surfaceContainerLowest: Color(0xff040804),
      surfaceContainerLow: Color(0xff191f19),
      surfaceContainer: Color(0xff242923),
      surfaceContainerHigh: Color(0xff2e342d),
      surfaceContainerHighest: Color(0xff393f38),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc2ffc3),
      surfaceTint: Color(0xff78dc86),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff75d782),
      onPrimaryContainer: Color(0xff000f02),
      secondary: Color(0xffd1fbcf),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffa5cda4),
      onSecondaryContainer: Color(0xff000f02),
      tertiary: Color(0xffedefff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffabc2ff),
      onTertiaryContainer: Color(0xff000a25),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0f150f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f3e3),
      outlineVariant: Color(0xffbac6b7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4da),
      inversePrimary: Color(0xff00541f),
      primaryFixed: Color(0xff94f99f),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff78dc86),
      onPrimaryFixedVariant: Color(0xff001504),
      secondaryFixed: Color(0xffc4edc2),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffa8d1a8),
      onSecondaryFixedVariant: Color(0xff001504),
      tertiaryFixed: Color(0xffd9e2ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb0c6ff),
      onTertiaryFixedVariant: Color(0xff000f31),
      surfaceDim: Color(0xff0f150f),
      surfaceBright: Color(0xff4c524a),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b211b),
      surfaceContainer: Color(0xff2c322b),
      surfaceContainerHigh: Color(0xff373d36),
      surfaceContainerHighest: Color(0xff424841),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    // ignore: deprecated_member_use
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
