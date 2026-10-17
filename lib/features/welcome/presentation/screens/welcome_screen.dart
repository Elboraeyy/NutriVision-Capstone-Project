import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_status_bar.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, this.onSignIn, this.onSignUp});

  final VoidCallback? onSignIn;
  final VoidCallback? onSignUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: AppColors.cream,
        child: Column(
          children: [
            const _WelcomeHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _Introduction(),
                    _EntryActions(onSignIn: onSignIn, onSignUp: onSignUp),
                  ],
                ),
              ),
            ),
            const _HomeIndicatorArea(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(64),
          bottomRight: Radius.circular(64),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: DesignStatusBar(
                assetPath: AppAssets.welcomeDeviceStatus,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'NutriVision',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'A little clarity. Every day.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFE1E8D6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Introduction extends StatelessWidget {
  const _Introduction();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 222,
          child: Center(
            child: Image.asset(
              AppAssets.foodIllustration,
              width: 338.653,
              height: 174.738,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const _ValueProposition(),
        const SizedBox(height: 20),
        const _Benefits(),
      ],
    );
  }
}

class _ValueProposition extends StatelessWidget {
  const _ValueProposition();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 37,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'Eat well. Feel good.',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  height: 1.15,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 37,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'Find your balance.',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 41,
          child: Text(
            'Log your meals, understand your nutrition, and discover food that fits your life.',
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _Benefits extends StatelessWidget {
  const _Benefits();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _Benefit(
            backgroundColor: AppColors.softGreen,
            assetPath: AppAssets.scanLine,
            label: 'Scan meals',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _Benefit(
            backgroundColor: AppColors.yellow,
            assetPath: AppAssets.utensils,
            label: 'Find recipes',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _Benefit(
            backgroundColor: AppColors.peach,
            assetPath: AppAssets.sprout,
            label: 'Your goals',
          ),
        ),
      ],
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({
    required this.backgroundColor,
    required this.assetPath,
    required this.label,
  });

  final Color backgroundColor;
  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(assetPath, width: 20, height: 20),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryActions extends StatelessWidget {
  const _EntryActions({this.onSignIn, this.onSignUp});

  final VoidCallback? onSignIn;
  final VoidCallback? onSignUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActionButton(
          label: 'Sign Up',
          labelColor: AppColors.lime,
          backgroundColor: AppColors.green,
          circleColor: AppColors.lime,
          onPressed: onSignUp,
        ),
        const SizedBox(height: 10),
        _ActionButton(
          label: 'Sign In',
          labelColor: AppColors.green,
          backgroundColor: AppColors.cream,
          circleColor: AppColors.softGreen,
          borderColor: AppColors.borderGreen,
          onPressed: onSignIn,
        ),
        const SizedBox(height: 10),
        const Text(
          'Your preferences. Your pace.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.mutedGreen,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    required this.circleColor,
    this.borderColor,
    this.onPressed,
  });

  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final Color circleColor;
  final Color? borderColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          height: 52,
          padding: const EdgeInsets.only(left: 20, right: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100),
            border: borderColor == null
                ? null
                : Border.all(color: borderColor!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  AppAssets.arrowRight,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeIndicatorArea extends StatelessWidget {
  const _HomeIndicatorArea();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: SizedBox(width: 128, height: 5),
        ),
      ),
    );
  }
}
