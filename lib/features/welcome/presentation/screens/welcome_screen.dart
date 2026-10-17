import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/design_status_bar.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, this.onSignIn, this.onSignUp});

  final VoidCallback? onSignIn;
  final VoidCallback? onSignUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const _WelcomeHeader(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.value(context, 20),
                AppResponsive.value(context, 18),
                AppResponsive.value(context, 20),
                0,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _Introduction(),
                        const Spacer(),
                        _EntryActions(onSignIn: onSignIn, onSignUp: onSignUp),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _HomeIndicatorArea(),
        ],
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.value(context, 210),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 70)),
          bottomRight: Radius.circular(AppResponsive.value(context, 70)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: AppResponsive.value(context, 44),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.value(context, 10),
              ),
              child: const DesignStatusBar(
                assetPath: AppAssets.welcomeDeviceStatus,
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 22)),
          Text(
            'NutriVision',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.font(context, 27),
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          Text(
            'A little clarity. Every day.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: AppResponsive.font(context, 12),
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
    final size = MediaQuery.sizeOf(context);
    final illustrationWidth = math.min(
      AppResponsive.value(context, 340),
      size.width - AppResponsive.value(context, 12),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: AppResponsive.value(context, 220),
          child: Center(
            child: Image.asset(
              AppAssets.foodIllustration,
              width: illustrationWidth,
              height: illustrationWidth * .52,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 14)),
        const _ValueProposition(),
        SizedBox(height: AppResponsive.value(context, 18)),
        const _Benefits(),
      ],
    );
  }
}

class _ValueProposition extends StatelessWidget {
  const _ValueProposition();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Eat well. Feel good.',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: AppResponsive.font(context, 31),
            fontWeight: FontWeight.w300,
            height: 1.15,
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 5)),
        Text(
          'Find your balance.',
          style: TextStyle(
            color: AppColors.green,
            fontSize: AppResponsive.font(context, 31),
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 10)),
        Text(
          'Log your meals, understand your nutrition, and discover food that fits your life.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.mutedGreen,
            fontSize: AppResponsive.font(context, 13),
            fontWeight: FontWeight.w400,
            height: 1.4,
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
    return Row(
      children: [
        const Expanded(
          child: _Benefit(
            backgroundColor: AppColors.softGreen,
            assetPath: AppAssets.scanLine,
            label: 'Scan meals',
          ),
        ),
        SizedBox(width: AppResponsive.value(context, 9)),
        const Expanded(
          child: _Benefit(
            backgroundColor: AppColors.yellow,
            assetPath: AppAssets.utensils,
            label: 'Find recipes',
          ),
        ),
        SizedBox(width: AppResponsive.value(context, 9)),
        const Expanded(
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
      height: AppResponsive.value(context, 72),
      padding: EdgeInsets.all(AppResponsive.value(context, 13)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            assetPath,
            width: AppResponsive.value(context, 22),
            height: AppResponsive.value(context, 22),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 11),
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
        SizedBox(height: AppResponsive.value(context, 11)),
        _ActionButton(
          label: 'Sign In',
          labelColor: AppColors.green,
          backgroundColor: AppColors.cream,
          circleColor: AppColors.softGreen,
          borderColor: AppColors.borderGreen,
          onPressed: onSignIn,
        ),
        SizedBox(height: AppResponsive.value(context, 11)),
        Text(
          'Your preferences. Your pace.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.mutedGreen,
            fontSize: AppResponsive.font(context, 11),
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
          height: AppResponsive.value(context, 56),
          padding: EdgeInsets.only(
            left: AppResponsive.value(context, 21),
            right: AppResponsive.value(context, 8),
          ),
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
                  fontSize: AppResponsive.font(context, 16),
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              Container(
                width: AppResponsive.value(context, 40),
                height: AppResponsive.value(context, 40),
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.green,
                  size: AppResponsive.value(context, 21),
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
    return SizedBox(
      height: AppResponsive.value(context, 30),
      child: Center(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: SizedBox(
            width: AppResponsive.value(context, 128),
            height: AppResponsive.value(context, 5),
          ),
        ),
      ),
    );
  }
}
