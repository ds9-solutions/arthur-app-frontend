import 'package:flutter/material.dart';

import 'breakpoints.dart';
import 'layout_type.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? fallback;
  final Widget? compact;

  const ResponsiveLayout({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.fallback,
    this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final layout = AppBreakpoints.getLayout(MediaQuery.of(context).size.width);
    final density = AppVerticalBreakpoints.getDensity(
      MediaQuery.of(context).size.height,
    );

    if (density == VerticalDensity.compact && compact != null) {
      return compact!;
    }

    switch (layout) {
      case LayoutType.mobile:
        return mobile ?? fallback ?? desktop ?? const _LayoutPlaceholder();
      case LayoutType.tablet:
        return tablet ?? fallback ?? desktop ?? const _LayoutPlaceholder();
      case LayoutType.desktop:
        return desktop ?? fallback ?? const _LayoutPlaceholder();
    }
  }
}

/// Evita [SizedBox.shrink] em scrollables: área zero pode quebrar o hit-testing.
class _LayoutPlaceholder extends StatelessWidget {
  const _LayoutPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(child: SizedBox(width: 1, height: 1));
  }
}
