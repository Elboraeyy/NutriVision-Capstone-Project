import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../widgets/analyzing_meal_widgets.dart';

/// Thin route screen shown while an uploaded or captured meal photo is analyzed.
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
        header: AnalyzingHeader(
          headerHeight: _headerHeight,
          onCancel: handleCancel,
        ),
        body: _AnalyzingBody(
          headerHeight: _headerHeight,
          onContinue: onContinue,
          onCancel: handleCancel,
        ),
      ),
    );
  }
}

class _AnalyzingBody extends StatelessWidget {
  const _AnalyzingBody({
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
          const AnalyzingStatusCard(),
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
