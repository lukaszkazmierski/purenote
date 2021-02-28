import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Theme {
  ThemeData getTheme();
  Color get listTileIconColor;
}

class LightTheme implements Theme {
  @override
  ThemeData getTheme() => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
        accentColor: const Color(0xff009688),
        accentColorBrightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xfffafafa),
        bottomAppBarColor: const Color(0xffffffff),
        cardColor: const Color(0xffffffff),
        dividerColor: const Color(0x1f000000),
        highlightColor: const Color(0x66bcbcbc),
        splashColor: const Color(0x66c8c8c8),
        selectedRowColor: const Color(0xfff5f5f5),
        unselectedWidgetColor: const Color(0x8a000000),
        disabledColor: const Color(0x61000000),
        textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Color(0xff80cbc4),
            cursorColor: Color(0xff4285f4),
            selectionHandleColor: Color(0xff4db6ac)),
        iconTheme: const IconThemeData(opacity: 1, size: 24),
        textTheme: const TextTheme(
          //ListTile
          subtitle1: TextStyle(
            color: Color(0xdd000000),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        backgroundColor: const Color(0xff80cbc4),
        dialogBackgroundColor: const Color(0xffffffff),
        indicatorColor: const Color(0xff009688),
        hintColor: const Color(0x8a000000),
        errorColor: const Color(0xffd32f2f),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xff009688)),
        focusColor: const Color(0x1f000000),
        hoverColor: const Color(0x0a000000),
      );

  Color get listTileIconColor => const Color(0xdd000000);
}

Theme lightTheme = LightTheme();
