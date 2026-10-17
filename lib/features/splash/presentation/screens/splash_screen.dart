import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/design_status_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.displayDuration = const Duration(milliseconds: 1200),
  });

  final Duration displayDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.displayDuration, _openWelcomeScreen);
  }

  void _openWelcomeScreen() {
    if (!mounted) return;
    context.go('/welcome');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = AppResponsive.scale(context);

    return Scaffold(
      backgroundColor: AppColors.green,
      body: ColoredBox(
        color: AppColors.green,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: 0,
              left: 8,
              right: 8,
              height: 40,
              child: DesignStatusBar(assetPath: AppAssets.deviceStatus),
            ),
            Center(
              child: SvgPicture.asset(
                AppAssets.logo,
                width: 213 * scale,
                height: 168 * scale,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
