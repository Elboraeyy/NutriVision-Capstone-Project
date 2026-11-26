import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';

/// Camera capture and gallery picker screen for scanning a meal.
///
/// Refactored to align with NutriVision design language: AppColors, AppResponsive,
/// rounded card surfaces, AppOverlayScaffold, and cohesive typography.
class CameraScannerScreen extends StatelessWidget {
  const CameraScannerScreen({
    super.key,
    this.onBack,
    this.onChoosePhoto,
    this.onTakePhoto,
  });

  final VoidCallback? onBack;
  final VoidCallback? onChoosePhoto;
  final VoidCallback? onTakePhoto;

  static const double _headerHeight = 165;

  void _openAnalyzing(BuildContext context) {
    GoRouter.maybeOf(context)?.pushNamed('meal-analyzing');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: _CameraScannerHeader(
          headerHeight: _headerHeight,
          onBack: onBack ?? () => Navigator.maybePop(context),
        ),
        body: _CameraScannerContent(
          headerHeight: _headerHeight,
          onChoosePhoto: onChoosePhoto ?? () => _openAnalyzing(context),
          onTakePhoto: onTakePhoto ?? () => _openAnalyzing(context),
        ),
      ),
    );
  }
}

class _CameraScannerHeader extends StatelessWidget {
  const _CameraScannerHeader({
    required this.headerHeight,
    required this.onBack,
  });

  final double headerHeight;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      height: topInset + AppResponsive.value(context, headerHeight),
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 20),
        topInset + AppResponsive.value(context, 10),
        AppResponsive.value(context, 20),
        AppResponsive.value(context, 18),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 38)),
          bottomRight: Radius.circular(AppResponsive.value(context, 38)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.value(context, 4),
                      vertical: AppResponsive.value(context, 4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: AppResponsive.value(context, 15),
                        ),
                        SizedBox(width: AppResponsive.value(context, 6)),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppResponsive.font(context, 13),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 10),
                  vertical: AppResponsive.value(context, 4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.softGreen.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.center_focus_strong_rounded,
                      color: AppColors.lime,
                      size: AppResponsive.value(context, 13),
                    ),
                    SizedBox(width: AppResponsive.value(context, 4)),
                    Text(
                      'SCANNER',
                      style: TextStyle(
                        color: AppColors.lime,
                        fontSize: AppResponsive.font(context, 10),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Scan your meal',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppResponsive.font(context, 26),
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'A quick photo. A clearer food diary.',
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: AppResponsive.font(context, 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraScannerContent extends StatelessWidget {
  const _CameraScannerContent({
    required this.headerHeight,
    required this.onChoosePhoto,
    required this.onTakePhoto,
  });

  final double headerHeight;
  final VoidCallback onChoosePhoto;
  final VoidCallback onTakePhoto;

  @override
  Widget build(BuildContext context) {
    final topPadding =
        AppOverlayScaffold.contentTop(context, headerHeight) +
        AppResponsive.value(context, 14);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 18),
        topPadding,
        AppResponsive.value(context, 18),
        AppResponsive.value(context, 32),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppResponsive.value(context, 24),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGreen.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppResponsive.value(context, 24),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1547592180-85f173990554'
                    '?auto=format&fit=crop&w=900&q=85',
                    height: AppResponsive.value(context, 320),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        height: AppResponsive.value(context, 320),
                        color: AppColors.softGreen,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.restaurant_rounded,
                          size: AppResponsive.value(context, 54),
                          color: AppColors.green,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: AppResponsive.value(context, 12),
                    right: AppResponsive.value(context, 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => AppToast.show(
                          context,
                          message: 'Language selection will be available soon.',
                          type: AppToastType.info,
                        ),
                        icon: Icon(
                          Icons.translate_rounded,
                          color: Colors.white,
                          size: AppResponsive.value(context, 18),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: AppResponsive.value(context, 14),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.value(context, 14),
                        vertical: AppResponsive.value(context, 8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '1× zoom · AI ready',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppResponsive.font(context, 11),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 20)),
          Text(
            'Keep the whole meal in view',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 18),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'Good light helps us estimate portions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 13),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 24)),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    AppResponsive.value(context, 20),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      AppResponsive.value(context, 20),
                    ),
                    onTap: onChoosePhoto,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppResponsive.value(context, 16),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppResponsive.value(context, 20),
                        ),
                        border: Border.all(
                          color: AppColors.softGreen,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: AppResponsive.value(context, 26),
                            color: AppColors.darkGreen,
                          ),
                          SizedBox(height: AppResponsive.value(context, 8)),
                          Text(
                            'Choose photo',
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: AppResponsive.font(context, 13),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 12)),
              Expanded(
                child: Material(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(
                    AppResponsive.value(context, 20),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      AppResponsive.value(context, 20),
                    ),
                    onTap: onTakePhoto,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppResponsive.value(context, 16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: AppResponsive.value(context, 26),
                            color: AppColors.lime,
                          ),
                          SizedBox(height: AppResponsive.value(context, 8)),
                          Text(
                            'Take photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppResponsive.font(context, 13),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 20)),
          Text(
            "You'll review everything before saving.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
            ),
          ),
        ],
      ),
    );
  }
}
