import 'package:flutter/material.dart';

extension BuildContextElevation on BuildContext {
  AppElevation get elevation => const AppElevation();
}

class AppElevation {
  const AppElevation();

  List<BoxShadow> get level1 => AppElevationTokens.level1;
  List<BoxShadow> get level2 => AppElevationTokens.level2;
  List<BoxShadow> get level3 => AppElevationTokens.level3;
}

/// Sombras para hierarquia visual da marca Arthur.
class AppElevationTokens {
  AppElevationTokens._();

  static const List<BoxShadow> level1 = [
    BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 3),
  ];

  static const List<BoxShadow> level2 = [
    BoxShadow(color: Color(0x7A000000), offset: Offset(0, 4), blurRadius: 8),
  ];

  static const List<BoxShadow> level3 = [
    BoxShadow(color: Color(0x8F000000), offset: Offset(0, 8), blurRadius: 24),
  ];
}
