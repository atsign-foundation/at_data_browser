import 'package:flutter/material.dart';

// 00b7ff
// ocean horizon: 005477
// tide pool blue: 0a569a

const kCaribbeanShallows = Color(0XFF57cbe7);
const kAlternativeColor = Color(0XFF42C1BA);

class AppTheme {
  static TextTheme lightTextTheme = const TextTheme(
    displayLarge: TextStyle(
      fontSize: 80,
      fontWeight: FontWeight.bold,
      // letterSpacing: -1.5,
    ),
    displayMedium: TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.bold,
      // letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w800,
    ),
    headlineMedium: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w600,
      // letterSpacing: 0.25,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      // letterSpacing: 0.15,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      // letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      // letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      // letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      // letterSpacing: 0.25,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      // letterSpacing: 1.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      // letterSpacing: 0.4,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      // letterSpacing: 1.5,
    ),
  );

  // 2
  static TextTheme darkTextTheme = const TextTheme();

  // 3
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      // primaryColor: kPrimaryColor,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light().copyWith(
          // primary: kPrimaryColor,
          // onPrimary: kOnPrimaryColor,
          // primaryContainer: kPrimaryContainer,
          // onPrimaryContainer: kOnPrimaryContainer,
          // secondary: kSecondaryColor,
          // onSecondary: kOnSecondaryColor,
          // secondaryContainer: kSecondaryContainer,
          // onSecondaryContainer: kOnSecondaryContainer,
          // tertiary: kTertiaryColor,
          // onTertiary: kOnTertiaryColor,
          // tertiaryContainer: kTertiaryContainer,
          // onTertiaryContainer: kOnTertiaryContainer,
          // error: kErrorColor,
          // onError: kOnError,
          // errorContainer: kErrorContainer,
          // onErrorContainer: kOnErrorContainer,
          // background: kBackgroundColor,
          // onBackground: kOnBackground,
          // surface: kSurface,
          // onSurface: kOnSurface,
          ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            return Colors.black;
          },
        ),
      ),
      appBarTheme: AppBarTheme(
          foregroundColor: Colors.white, backgroundColor: Colors.white, titleTextStyle: lightTextTheme.bodyMedium),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Color(0xFFF8C630),
        backgroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        // backgroundColor: kPrimaryColor,
        // selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        // selectedLabelStyle: const TextStyle().copyWith(fontSize: 20),
        // unselectedLabelStyle: const TextStyle().copyWith(fontSize: 20),
      ),
      textTheme: lightTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF12DE26)),
          foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
        ),
      ),
      dialogTheme: const DialogTheme(
        surfaceTintColor: Colors.white,
      ),

      cardTheme: const CardTheme(
        elevation: 0,
        surfaceTintColor: Colors.white,
        color: Color(0xFFF4F4F4),
      ),
    );
  }

  // 4
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark().copyWith(
          // primary: kPrimaryColorDark,
          // onPrimary: kOnPrimaryColorDark,
          // primaryContainer: kPrimaryContainerDark,
          // onPrimaryContainer: kOnPrimaryContainerDark,
          // secondary: kSecondaryColorDark,
          // onSecondary: kOnSecondaryColorDark,
          // secondaryContainer: kSecondaryContainerDark,
          // onSecondaryContainer: kOnSecondaryContainerDark,
          // tertiary: kTertiaryColorDark,
          // onTertiary: kOnTertiaryColorDark,
          // tertiaryContainer: kTertiaryContainerDark,
          // onTertiaryContainer: kOnTertiaryContainerDark,
          // error: kErrorColorDark,
          // onError: kOnErrorDark,
          // errorContainer: kErrorContainerDark,
          // onErrorContainer: kOnErrorContainerDark,
          // background: kBackgroundColorDark,
          // onBackground: kOnBackgroundDark,
          // surface: kSurfaceDark,
          // onSurface: kOnSurfaceDark,
          ),
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),

      textTheme: darkTextTheme,
      // iconTheme: const IconThemeData(color: kSecondaryColor),
    );
  }
}
