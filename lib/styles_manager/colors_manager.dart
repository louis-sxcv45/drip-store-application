import 'package:flutter/material.dart';

class ColorsManager {
  static Color primary = HexColor.fromHex('#3F51B5');
  static Color secondary = HexColor.fromHex('#2196F3');
  static Color cyan = HexColor.fromHex('#00BCD4');
  static Color white = HexColor.fromHex('#FFFFFF');
  static Color black = HexColor.fromHex('#000000');
  static Color grey = HexColor.fromHex('#757575');
  static Color platinum = HexColor.fromHex('#DEDEDE');
  static Color celestialBlue = HexColor.fromHex('#0E75E2');
  static Color blue = HexColor.fromHex('#0601B4');
  static Color seasalt = HexColor.fromHex('#F9F9F9');
  static Color red = HexColor.fromHex('#F01E2C');
}

extension HexColor on Color {
  static Color fromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }

    return Color(int.parse(hexColor, radix: 16));
  }
  
}