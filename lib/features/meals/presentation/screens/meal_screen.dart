import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../widgets/meal_review_widgets.dart';

/// Thin route screen for reviewing and adjusting detected meal foods and portions.
class MealScreen extends StatelessWidget {
  const MealScreen({super.key, this.onAddFood, this.onConfirm});

  final VoidCallback? onAddFood;
  final VoidCallback? onConfirm;

  static const double _headerHeight = 165;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: const MealReviewHeader(headerHeight: _headerHeight),
        body: _MealReviewBody(
          headerHeight: _headerHeight,
          onAddFood: onAddFood,
          onConfirm: onConfirm,
        ),
      ),
    );
  }
}

class _MealReviewBody extends StatelessWidget {
  const _MealReviewBody({
    required this.headerHeight,
    required this.onAddFood,
    required this.onConfirm,
  });

  final double headerHeight;
  final VoidCallback? onAddFood;
  final VoidCallback? onConfirm;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MealInfoCard(),
          SizedBox(height: AppResponsive.value(context, 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Foods & portions',
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 18),
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 9),
                  vertical: AppResponsive.value(context, 4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '4 items detected',
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 11),
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'Correct detected foods and portions before saving.',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 12),
              color: AppColors.mutedGreen,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          const FoodItemCard(name: 'Grilled chicken', amount: '100'),
          SizedBox(height: AppResponsive.value(context, 10)),
          const FoodItemCard(name: 'Cooked quinoa', amount: '150'),
          SizedBox(height: AppResponsive.value(context, 10)),
          const FoodItemCard(name: 'Avocado', amount: '40', warning: true),
          SizedBox(height: AppResponsive.value(context, 10)),
          const FoodItemCard(name: 'Mixed vegetables', amount: '80'),
          SizedBox(height: AppResponsive.value(context, 12)),
          SizedBox(
            width: double.infinity,
            height: AppResponsive.value(context, 44),
            child: OutlinedButton.icon(
              onPressed:
                  onAddFood ??
                  () => AppToast.show(
                    context,
                    message: 'Custom food search will be available soon.',
                    type: AppToastType.info,
                  ),
              icon: Icon(
                Icons.add_rounded,
                size: AppResponsive.value(context, 18),
              ),
              label: Text(
                'Add a missed food',
                style: TextStyle(
                  fontSize: AppResponsive.font(context, 13),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkGreen,
                side: const BorderSide(color: AppColors.borderGreen),
                shape: const StadiumBorder(),
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          const PortionWarningCard(),
          SizedBox(height: AppResponsive.value(context, 16)),
          const MealNutritionBreakdown(),
          SizedBox(height: AppResponsive.value(context, 14)),
          Text(
            'Nutrition values are estimates, not medical advice.',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 11),
              color: AppColors.mutedGreen,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 18)),
          ConfirmSaveButton(
            onPressed:
                onConfirm ??
                () => AppToast.show(
                  context,
                  message: 'Meal saving will be connected soon.',
                  type: AppToastType.info,
                ),
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          Center(
            child: Text(
              'Confirmed food updates Diary, Home and Progress together.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppResponsive.font(context, 11),
                color: AppColors.mutedGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
