import 'package:flutter/material.dart';

/// Tema padrão do app, aplicado no MaterialApp no arquivo main.dart e
/// ao longo do app quando são necessárias cores para botões, textos etc.
class Style {

  // ===== TEMA PADRÃO ===== //
  static ThemeData main = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    accentColor: accentColor,
    primarySwatch: Colors.green,
    primaryColorDark: primaryColorDark,
    dividerColor: const Color.fromARGB(0, 0, 0, 0),
  );

  static const Color primaryColor = Color.fromARGB(255, 182, 235, 122);
  static const Color primaryColorDark = Color.fromARGB(255, 23, 112, 110);
  static const Color accentColor = Color.fromARGB(255, 251, 120, 19);
  static const Color clearWhite = Color.fromARGB(255, 247, 247, 238);

  // ===== CORES EXTRAS ===== //
  static const Color lightGrey = Color.fromARGB(255, 240, 240, 240);
  static const Color darkText = Colors.black45;
}