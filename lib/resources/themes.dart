import 'package:flutter/material.dart';
import 'package:salbang/resources/colors.dart';

ThemeData salbangTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    primaryColor: colorBlack,
    scaffoldBackgroundColor: colorScaffold,
    cardColor: colorWhite,
    hintColor: Colors.black,
    errorColor: Colors.red,
    buttonColor: colorButtonAdd,
    // FONT THEMES
    primaryTextTheme: _salbangThemeTextTheme(base.primaryTextTheme),
    // ICON THEMES ( CHANGE COLOR )
    primaryIconTheme: base.iconTheme.copyWith(color: Colors.black),
  );
}

TextTheme _salbangThemeTextTheme(TextTheme base) {
  return base
      .copyWith(
        title: base.title.copyWith(
            fontSize: 20.0,
            fontWeight: FontWeight.w400,
            color: colorAltDarkGrey),
        display1: base.display1.copyWith(
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            color: colorAltDarkGrey),
        display2: base.display2.copyWith(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: colorAltDarkGrey),
      )
      .apply();
}
