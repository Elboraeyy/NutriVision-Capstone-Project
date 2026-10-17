import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_status_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.displayDuration = const Duration(milliseconds: 1200),
  });

  final Duration displayDuration;

  static const _headerHeight = 998.0;
  static const _cornerRadius = 64.0;

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
    return Scaffold(
      body: ColoredBox(
        color: AppColors.cream,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(SplashScreen._cornerRadius),
            bottomRight: Radius.circular(SplashScreen._cornerRadius),
          ),
          child: SizedBox(
            width: double.infinity,
            height: SplashScreen._headerHeight,
            child: ColoredBox(
              color: AppColors.green,
              child: Stack(
                children: [
                  const Positioned(
                    top: 0,
                    left: 8,
                    right: 8,
                    height: 40,
                    child: DesignStatusBar(
                      assetPath: AppAssets.deviceStatus,
                    ),
                  ),
                  Positioned(
                    top: SplashScreen._headerHeight / 2 - 60,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: const Offset(4.5, -84),
                        child: SvgPicture.asset(
                          AppAssets.logo,
                          width: 213,
                          height: 168,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
