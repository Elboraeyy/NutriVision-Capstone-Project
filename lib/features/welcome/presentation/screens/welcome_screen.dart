import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_green_header.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, this.onSignIn, this.onSignUp});

  final VoidCallback? onSignIn;
  final VoidCallback? onSignUp;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _headerFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, .6, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0, .7, curve: Curves.easeOutCubic),
          ),
        );
    _contentFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(.2, 1, curve: Curves.easeOut),
    );
    _contentSlide = Tween<Offset>(begin: const Offset(0, .06), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(.2, 1, curve: Curves.easeOutCubic),
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).height < 870;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: FadeTransition(
          opacity: _headerFade,
          child: SlideTransition(
            position: _headerSlide,
            child: const AppGreenHeader(
              title: 'NutriVision',
              subtitle: 'A little clarity. Every day.',
              height: 175,
              cornerRadius: 70,
            ),
          ),
        ),
        body: FadeTransition(
          opacity: _contentFade,
          child: SlideTransition(
            position: _contentSlide,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.value(context, 20),
                0,
                AppResponsive.value(context, 20),
                0,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top:
                          AppOverlayScaffold.contentTop(context, 175) +
                          AppResponsive.value(context, 18),
                    ),
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Introduction(compact: isCompact),
                          const Spacer(),
                          _EntryActions(
                            compact: isCompact,
                            onSignIn: widget.onSignIn,
                            onSignUp: widget.onSignUp,
                          ),
                        ],
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

class _Introduction extends StatelessWidget {
  const _Introduction({this.compact = false});

  final bool compact;

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
          height: AppResponsive.value(context, compact ? 195 : 220),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.foodIllustration,
              width: illustrationWidth,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: AppResponsive.value(context, compact ? 10 : 14)),
        const _ValueProposition(),
        SizedBox(height: AppResponsive.value(context, compact ? 12 : 18)),
        _Benefits(compact: compact),
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
  const _Benefits({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Benefit(
            compact: compact,
            backgroundColor: AppColors.softGreen,
            assetPath: AppAssets.scanLine,
            label: 'Scan meals',
          ),
        ),
        SizedBox(width: AppResponsive.value(context, 9)),
        Expanded(
          child: _Benefit(
            compact: compact,
            backgroundColor: AppColors.yellow,
            assetPath: AppAssets.utensils,
            label: 'Find recipes',
          ),
        ),
        SizedBox(width: AppResponsive.value(context, 9)),
        Expanded(
          child: _Benefit(
            compact: compact,
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
    this.compact = false,
    required this.backgroundColor,
    required this.assetPath,
    required this.label,
  });

  final Color backgroundColor;
  final String assetPath;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.value(context, compact ? 66 : 72),
      padding: EdgeInsets.all(AppResponsive.value(context, 13)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
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
  const _EntryActions({this.compact = false, this.onSignIn, this.onSignUp});

  final bool compact;
  final VoidCallback? onSignIn;
  final VoidCallback? onSignUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActionButton(
          compact: compact,
          label: 'Sign Up',
          labelColor: AppColors.lime,
          backgroundColor: AppColors.green,
          circleColor: AppColors.lime,
          onPressed: onSignUp,
        ),
        SizedBox(height: AppResponsive.value(context, compact ? 8 : 11)),
        _ActionButton(
          compact: compact,
          label: 'Sign In',
          labelColor: AppColors.green,
          backgroundColor: AppColors.cream,
          circleColor: AppColors.softGreen,
          borderColor: AppColors.borderGreen,
          onPressed: onSignIn,
        ),
        SizedBox(height: AppResponsive.value(context, compact ? 8 : 11)),
        Text(
          'Your preferences. Your pace.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.mutedGreen,
            fontSize: AppResponsive.font(context, compact ? 10 : 11),
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
    this.compact = false,
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
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          height: AppResponsive.value(context, compact ? 52 : 56),
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
                width: AppResponsive.value(context, compact ? 38 : 40),
                height: AppResponsive.value(context, compact ? 38 : 40),
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.arrowRight,
                  width: AppResponsive.value(context, 21),
                  height: AppResponsive.value(context, 21),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
