import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Responsive values shared by the UI.
///
/// Values are scaled from a 390x844 phone reference and clamped so the UI
/// remains usable on both small and large phones.
abstract final class AppResponsive {
  static double scale(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final widthScale = size.width / 390;
    final heightScale = size.height / 844;
    return math.min(widthScale, heightScale).clamp(.84, 1.14);
  }

  static double value(BuildContext context, double base) {
    return base * scale(context);
  }

  static double font(BuildContext context, double base) {
    final size = base * scale(context);
    return size.clamp(base * .9, base * 1.14);
  }
}
