import 'package:arthur/core/layout/layout_type.dart';

class AppBreakpoints {
  static const mobileMax = 768;
  static const tabletMax = 1024;

  static LayoutType getLayout(double width) {
    if (width <= mobileMax) return LayoutType.mobile;
    if (width <= tabletMax) return LayoutType.tablet;
    return LayoutType.desktop;
  }
}

class AppVerticalBreakpoints {
  static const compactMax = 600;
  static const normalMax = 900;

  static VerticalDensity getDensity(double height) {
    if (!height.isFinite || height <= 0) {
      return VerticalDensity.expanded;
    }
    if (height <= compactMax) return VerticalDensity.compact;
    if (height <= normalMax) return VerticalDensity.normal;
    return VerticalDensity.expanded;
  }
}
