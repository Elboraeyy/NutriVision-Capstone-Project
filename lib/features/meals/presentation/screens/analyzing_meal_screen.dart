import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';

/// Progress screen shown while an uploaded or captured meal photo is analyzed.
///
/// Refactored to align with NutriVision design language: AppColors, AppResponsive,
/// rounded card surfaces, AppOverlayScaffold, and cohesive typography.
class AnalyzingMealScreen extends StatelessWidget {
  const AnalyzingMealScreen({super.key, this.onCancel, this.onContinue});

  final VoidCallback? onCancel;
  final VoidCallback? onContinue;

  static const double _headerHeight = 165;

  @override
  Widget build(BuildContext context) {
    final handleCancel = onCancel ?? () => Navigator.maybePop(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: _AnalyzingHeader(
          headerHeight: _headerHeight,
          onCancel: handleCancel,
        ),
        body: _AnalyzingContent(
          headerHeight: _headerHeight,
          onContinue: onContinue,
          onCancel: handleCancel,
        ),
      ),
    );
  }
}

class _AnalyzingHeader extends StatelessWidget {
  const _AnalyzingHeader({required this.headerHeight, required this.onCancel});

  final double headerHeight;
  final VoidCallback onCancel;

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
                  onTap: onCancel,
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
                      Icons.auto_awesome_rounded,
                      color: AppColors.lime,
                      size: AppResponsive.value(context, 13),
                    ),
                    SizedBox(width: AppResponsive.value(context, 4)),
                    Text(
                      'AI VISION',
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
              'A closer look',
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
            'Getting to know your meal.',
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

class _AnalyzingContent extends StatelessWidget {
  const _AnalyzingContent({
    required this.headerHeight,
    required this.onContinue,
    required this.onCancel,
  });

  final double headerHeight;
  final VoidCallback? onContinue;
  final VoidCallback onCancel;

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
              child: Image.network(
                'https://images.unsplash.com/photo-1547592180-85f173990554'
                '?auto=format&fit=crop&w=900&q=85',
                width: double.infinity,
                height: AppResponsive.value(context, 260),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(
                    height: AppResponsive.value(context, 260),
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
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 18)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppResponsive.value(context, 18)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                AppResponsive.value(context, 22),
              ),
              border: Border.all(color: AppColors.softGreen, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGreen.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: AppResponsive.value(context, 32),
                      height: AppResponsive.value(context, 32),
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.green,
                        ),
                      ),
                    ),
                    SizedBox(width: AppResponsive.value(context, 14)),
                    Expanded(
                      child: Text(
                        'Analyzing your photo...',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: AppResponsive.font(context, 18),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.value(context, 12)),
                Text(
                  'Identifying foods and estimating portions. '
                  'You can adjust the details next.',
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 13),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 22)),
          SizedBox(
            width: double.infinity,
            height: AppResponsive.value(context, 48),
            child: ElevatedButton(
              onPressed:
                  onContinue ??
                  () => GoRouter.maybeOf(context)?.pushNamed('meal-review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Continue to review',
                style: TextStyle(
                  fontSize: AppResponsive.font(context, 14),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          SizedBox(
            width: double.infinity,
            height: AppResponsive.value(context, 46),
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkGreen,
                side: const BorderSide(color: AppColors.borderGreen),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Cancel analysis',
                style: TextStyle(
                  fontSize: AppResponsive.font(context, 13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          Text(
            'Nothing has been added to your diary.',
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
