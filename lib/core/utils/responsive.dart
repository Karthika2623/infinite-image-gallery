import 'package:flutter/material.dart';

/// Shared responsive values derived from the current device's MediaQuery.
/// Use these helpers instead of fixed dimensions across phone, tablet and desktop.
class Responsive {
  Responsive._();

  static Size size(BuildContext context) => MediaQuery.of(context).size;
  static double width(BuildContext context) => size(context).width;
  static double height(BuildContext context) => size(context).height;

  static bool isCompact(BuildContext context) => width(context) < 360;
  static bool isPhone(BuildContext context) => width(context) < 600;
  static bool isTablet(BuildContext context) => width(context) >= 600 && width(context) < 1024;
  static bool isDesktop(BuildContext context) => width(context) >= 1024;

  static double horizontalPadding(BuildContext context) {
    final w = width(context);
    if (w >= 1400) return 36;
    if (w >= 1024) return 28;
    if (w >= 600) return 24;
    if (w < 360) return 12;
    return 18;
  }

  static double contentMaxWidth(BuildContext context) =>
      isDesktop(context) ? 1320 : double.infinity;

  static int gridColumns(BuildContext context) {
    final w = width(context);
    if (w >= 1500) return 5;
    if (w >= 1100) return 4;
    if (w >= 700) return 3;
    return 2;
  }

  static double gridAspectRatio(BuildContext context) {
    final w = width(context);
    if (w >= 1100) return 0.82;
    if (w >= 700) return 0.76;
    if (w < 360) return 0.66;
    return 0.70;
  }

  static double titleSize(BuildContext context) {
    final w = width(context);
    if (w >= 1024) return 28;
    if (w >= 600) return 25;
    if (w < 360) return 18;
    return 21;
  }

  static double detailImageHeight(BuildContext context) {
    final h = height(context);
    final w = width(context);
    if (w >= 1024) return (h * 0.72).clamp(420.0, 760.0);
    if (w >= 600) return (h * 0.62).clamp(360.0, 620.0);
    return (h * 0.56).clamp(300.0, 520.0);
  }
}
