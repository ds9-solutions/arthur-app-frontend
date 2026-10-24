import 'package:flutter/widgets.dart';

import 'layout_type.dart';
import 'responsive_extensions.dart';

class ResponsiveValue<T> {
  final T mobile;
  final T tablet;
  final T desktop;

  const ResponsiveValue({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  T resolve(BuildContext context) {
    switch (context.layout) {
      case LayoutType.mobile:
        return mobile;
      case LayoutType.tablet:
        return tablet;
      case LayoutType.desktop:
        return desktop;
    }
  }
}
