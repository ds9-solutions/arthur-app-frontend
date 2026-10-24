import 'package:flutter/material.dart';

import 'breakpoints.dart';
import 'layout_type.dart';

extension ResponsiveContext on BuildContext {
  LayoutType get layout {
    final width = MediaQuery.of(this).size.width;
    return AppBreakpoints.getLayout(width);
  }

  VerticalDensity get density {
    final height = MediaQuery.of(this).size.height;
    return AppVerticalBreakpoints.getDensity(height);
  }

  bool get isMobile => layout == LayoutType.mobile;
  bool get isTablet => layout == LayoutType.tablet;
  bool get isDesktop => layout == LayoutType.desktop;

  bool get isCompact => density == VerticalDensity.compact;
}
