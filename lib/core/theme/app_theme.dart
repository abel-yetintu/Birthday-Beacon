import "package:flutter/material.dart";

class AppTheme {
  final TextTheme textTheme;

  const AppTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4285160773),
      surfaceTint: Color(4285160773),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4290488975),
      onPrimaryContainer: Color(4280885261),
      secondary: Color(4285750272),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294695021),
      onSecondaryContainer: Color(4283646208),
      tertiary: Color(4278195992),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4279580729),
      onTertiaryContainer: Color(4289054921),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294899956),
      onSurface: Color(4280097561),
      onSurfaceVariant: Color(4283188797),
      outline: Color(4286412396),
      outlineVariant: Color(4291741113),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281479214),
      inversePrimary: Color(4292265128),
      primaryFixed: Color(4294172866),
      onPrimaryFixed: Color(4280490504),
      primaryFixedDim: Color(4292265128),
      onPrimaryFixedVariant: Color(4283516207),
      secondaryFixed: Color(4294959239),
      onSecondaryFixed: Color(4280490496),
      secondaryFixedDim: Color(4293247835),
      onSecondaryFixedVariant: Color(4283909376),
      tertiaryFixed: Color(4291160554),
      onTertiaryFixed: Color(4278198305),
      tertiaryFixedDim: Color(4289383886),
      onTertiaryFixedVariant: Color(4281027661),
      surfaceDim: Color(4292794837),
      surfaceBright: Color(4294899956),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294505199),
      surfaceContainer: Color(4294110697),
      surfaceContainerHigh: Color(4293781475),
      surfaceContainerHighest: Color(4293386718),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292265128),
      surfaceTint: Color(4292265128),
      onPrimary: Color(4281937691),
      primaryContainer: Color(4289173629),
      onPrimaryContainer: Color(4279109632),
      secondary: Color(4294966265),
      onSecondary: Color(4282134272),
      secondaryContainer: Color(4294037092),
      onSecondaryContainer: Color(4283120384),
      tertiary: Color(4289383886),
      onTertiary: Color(4279383350),
      tertiaryContainer: Color(4278198562),
      onTertiaryContainer: Color(4287410095),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279571217),
      onSurface: Color(4293386718),
      onSurfaceVariant: Color(4291741113),
      outline: Color(4288123013),
      outlineVariant: Color(4283188797),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293386718),
      inversePrimary: Color(4285160773),
      primaryFixed: Color(4294172866),
      onPrimaryFixed: Color(4280490504),
      primaryFixedDim: Color(4292265128),
      onPrimaryFixedVariant: Color(4283516207),
      secondaryFixed: Color(4294959239),
      onSecondaryFixed: Color(4280490496),
      secondaryFixedDim: Color(4293247835),
      onSecondaryFixedVariant: Color(4283909376),
      tertiaryFixed: Color(4291160554),
      onTertiaryFixed: Color(4278198305),
      tertiaryFixedDim: Color(4289383886),
      onTertiaryFixedVariant: Color(4281027661),
      surfaceDim: Color(4279571217),
      surfaceBright: Color(4282071350),
      surfaceContainerLowest: Color(4279176716),
      surfaceContainerLow: Color(4280097561),
      surfaceContainer: Color(4280360733),
      surfaceContainerHigh: Color(4281084455),
      surfaceContainerHighest: Color(4281807922),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        inputDecorationTheme: _inputDecorationTheme(colorScheme),
        filledButtonTheme: _filledButtonTheme(colorScheme),
        outlinedButtonTheme: _outlineButtonTheme(colorScheme),
      );

  InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.outline,
        ),
      ),
    );
  }

  FilledButtonThemeData _filledButtonTheme(ColorScheme colorScheme) {
    return const FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  OutlinedButtonThemeData _outlineButtonTheme(ColorScheme colorScheme) {
    return const OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
