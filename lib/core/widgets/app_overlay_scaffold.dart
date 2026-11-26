import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_responsive.dart';

/// Places a screen header above a scrollable body while keeping the space
/// around the header transparent and allowing the body to move underneath it.
class AppOverlayScaffold extends StatelessWidget {
  const AppOverlayScaffold({
    super.key,
    required this.header,
    required this.body,
    this.foreground,
    this.foregrounds,
  });

  final Widget header;
  final Widget body;
  final Widget? foreground;
  final List<Widget>? foregrounds;

  static double contentTop(BuildContext context, double headerHeight) {
    return MediaQuery.paddingOf(context).top +
        AppResponsive.value(context, headerHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      extendBody: true,
      body: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: body),
            Positioned(top: 0, left: 0, right: 0, child: header),
            ...?foregrounds,
            if (foregrounds == null && foreground != null) foreground!,
          ],
        ),
      ),
    );
  }
}
