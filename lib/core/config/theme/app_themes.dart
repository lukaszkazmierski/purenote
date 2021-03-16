import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  ThemeData getTheme();
  Color get listTileIconColor;
  TextStyle textStyle({double fontSize, double height});
}

class LightTheme implements AppTheme {
  @override
  ThemeData getTheme() => ThemeData(
        //General
        brightness: Brightness.light,
        accentColor: const Color(0xff009688),
        accentColorBrightness: Brightness.dark,
        backgroundColor: const Color(0xff80cbc4),
        indicatorColor: const Color(0xff009688),
        dividerColor: const Color( 0x1f000000 ),
        //Splash
        highlightColor: const Color(0x66bcbcbc),
        splashColor: const Color(0x66c8c8c8),

        //disabled inoperative widgets
        unselectedWidgetColor: const Color(0x8a000000),
        disabledColor: const Color(0x61000000),

        //AppBar
        primaryColor: Colors.teal,

        //Scaffold
        scaffoldBackgroundColor: const Color(0xfffafafa),

        //Floating Button
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xff009688)),
        //Icons
        iconTheme: const IconThemeData(opacity: 1, size: 24),

        //Text & TextFields
        textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Color(0xff80cbc4),
            cursorColor: Color(0xff4285f4),
            selectionHandleColor: Color(0xff4db6ac)),

        textTheme: TextTheme(
          //ListTile title text
          subtitle1: GoogleFonts.openSans(
            color: const Color(0xdd000000),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          headline4: GoogleFonts.openSans(
            color: const Color(0xdd000000),
            fontSize: 30,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),

        hintColor: const Color(0x8a000000),
        errorColor: const Color(0xffd32f2f),
        focusColor: const Color(0x1f000000),
        hoverColor: const Color(0x0a000000),

        //Dialog
        dialogBackgroundColor: const Color(0xffffffff),

        //Scheme
        colorScheme: const ColorScheme(
          primary: Color(0xff009688),
          primaryVariant: Color(0xff00796b),
          secondary: Color(0xff009688),
          secondaryVariant: Color(0xff00796b),
          surface: Color(0xffffffff),
          background: Color(0xff80cbc4),
          error: Color(0xffd32f2f),
          onPrimary: Color(0xffffffff),
          onSecondary: Color(0xffffffff),
          onSurface: Color(0xff000000),
          onBackground: Color(0xffffffff),
          onError: Color(0xffffffff),
          brightness: Brightness.light,
        ),
      );

  @override
  Color get listTileIconColor => const Color(0xdd000000);

  @override
  TextStyle textStyle({double fontSize, double height}) =>
      GoogleFonts.openSans(fontSize: fontSize, height: height);
}

AppTheme lightTheme = LightTheme();
