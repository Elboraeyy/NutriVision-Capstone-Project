import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';

/// Meal review and portion adjustment screen for AI-detected or manual meals.
///
/// Refactored to align with NutriVision design language: AppColors, AppResponsive,
/// rounded surfaces, AppOverlayScaffold, and cohesive typography.
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
        header: const _MealReviewHeader(headerHeight: _headerHeight),
        body: _MealReviewContent(
          headerHeight: _headerHeight,
          onAddFood: onAddFood,
          onConfirm: onConfirm,
        ),
      ),
    );
  }
}

class _MealReviewHeader extends StatelessWidget {
  const _MealReviewHeader({required this.headerHeight});

  final double headerHeight;

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
                  onTap: () => Navigator.maybePop(context),
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
                      'AI REVIEW',
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
              'Make it your meal',
              style: TextStyle(
                fontSize: AppResponsive.font(context, 26),
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.15,
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'AI results & review · Not yet in your diary',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 13),
              color: AppColors.softGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealReviewContent extends StatelessWidget {
  const _MealReviewContent({
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
          const _MealInfoCard(),
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
          const _FoodItemCard(name: 'Grilled chicken', amount: '100'),
          SizedBox(height: AppResponsive.value(context, 10)),
          const _FoodItemCard(name: 'Cooked quinoa', amount: '150'),
          SizedBox(height: AppResponsive.value(context, 10)),
          const _FoodItemCard(name: 'Avocado', amount: '40', warning: true),
          SizedBox(height: AppResponsive.value(context, 10)),
          const _FoodItemCard(name: 'Mixed vegetables', amount: '80'),
          SizedBox(height: AppResponsive.value(context, 12)),
          _AddFoodButton(
            onPressed:
                onAddFood ??
                () => AppToast.show(
                  context,
                  message: 'Custom food search will be available soon.',
                  type: AppToastType.info,
                ),
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          const _PortionWarningCard(),
          SizedBox(height: AppResponsive.value(context, 16)),
          const _MealNutritionBreakdown(),
          SizedBox(height: AppResponsive.value(context, 14)),
          Text(
            'Nutrition values are estimates, not medical advice.',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 11),
              color: AppColors.mutedGreen,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 18)),
          _ConfirmSaveButton(
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

class _MealInfoCard extends StatelessWidget {
  const _MealInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 22)),
        border: Border.all(color: AppColors.softGreen, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppResponsive.value(context, 18),
                ),
                child: Image.network(
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200',
                  width: AppResponsive.value(context, 68),
                  height: AppResponsive.value(context, 68),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: AppResponsive.value(context, 68),
                    height: AppResponsive.value(context, 68),
                    color: AppColors.softGreen,
                    child: Icon(
                      Icons.restaurant_rounded,
                      size: AppResponsive.value(context, 30),
                      color: AppColors.green,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal name',
                      style: TextStyle(
                        fontSize: AppResponsive.font(context, 11),
                        color: AppColors.mutedGreen,
                      ),
                    ),
                    SizedBox(height: AppResponsive.value(context, 4)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.value(context, 10),
                        vertical: AppResponsive.value(context, 8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderGreen),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Chicken & quinoa bowl',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppResponsive.font(context, 14),
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkGreen,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.edit_outlined,
                            size: AppResponsive.value(context, 16),
                            color: AppColors.darkGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.value(context, 10),
                    vertical: AppResponsive.value(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGreen),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lunch_dining_rounded,
                        size: AppResponsive.value(context, 15),
                        color: AppColors.darkGreen,
                      ),
                      SizedBox(width: AppResponsive.value(context, 6)),
                      Expanded(
                        child: Text(
                          'Dinner',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 13),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: AppResponsive.value(context, 18),
                        color: AppColors.darkGreen,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.value(context, 10),
                    vertical: AppResponsive.value(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGreen),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: AppResponsive.value(context, 15),
                        color: AppColors.darkGreen,
                      ),
                      SizedBox(width: AppResponsive.value(context, 6)),
                      Expanded(
                        child: Text(
                          'Today · 6:30 PM',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.edit_outlined,
                        size: AppResponsive.value(context, 15),
                        color: AppColors.darkGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FoodItemCard extends StatelessWidget {
  const _FoodItemCard({
    required this.name,
    required this.amount,
    this.warning = false,
  });

  final String name;
  final String amount;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 18)),
        border: Border.all(
          color: warning ? AppColors.yellow : AppColors.softGreen,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppResponsive.value(context, 8),
                height: AppResponsive.value(context, 8),
                decoration: BoxDecoration(
                  color: warning ? AppColors.yellow : AppColors.lime,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 14),
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              Icon(
                Icons.edit_outlined,
                color: AppColors.mutedGreen,
                size: AppResponsive.value(context, 16),
              ),
              SizedBox(width: AppResponsive.value(context, 10)),
              Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.shade300,
                size: AppResponsive.value(context, 18),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 8)),
          Row(
            children: [
              Expanded(
                child: Text(
                  warning ? 'Est. portion · check' : 'Est. portion',
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 11),
                    color: warning
                        ? const Color(0xFF946200)
                        : AppColors.mutedGreen,
                    fontWeight: warning ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              Container(
                width: AppResponsive.value(context, 65),
                height: AppResponsive.value(context, 34),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  border: Border.all(color: AppColors.borderGreen),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  amount,
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 14),
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 6)),
              Container(
                width: AppResponsive.value(context, 55),
                height: AppResponsive.value(context, 34),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  border: Border.all(color: AppColors.borderGreen),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'g',
                      style: TextStyle(
                        fontSize: AppResponsive.font(context, 12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: AppResponsive.value(context, 15),
                      color: AppColors.darkGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddFoodButton extends StatelessWidget {
  const _AddFoodButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppResponsive.value(context, 44),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.add_rounded, size: AppResponsive.value(context, 18)),
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
    );
  }
}

class _PortionWarningCard extends StatelessWidget {
  const _PortionWarningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 12)),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.darkGreen,
            size: AppResponsive.value(context, 20),
          ),
          SizedBox(width: AppResponsive.value(context, 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Avocado portion may need checking',
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 3)),
                Text(
                  'Check the amount before saving.',
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 12),
                    color: AppColors.darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealNutritionBreakdown extends StatelessWidget {
  const _MealNutritionBreakdown();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 15)),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 22)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Estimated nutrition',
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 15),
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              Text(
                '520',
                style: TextStyle(
                  fontSize: AppResponsive.font(context, 28),
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                  height: 1,
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 4)),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'kcal',
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 11),
                    color: AppColors.mutedGreen,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          Row(
            children: const [
              Expanded(
                child: _ReviewMacroPill(
                  label: 'Protein',
                  amount: '40 g',
                  color: AppColors.cream,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ReviewMacroPill(
                  label: 'Carbs',
                  amount: '54 g',
                  color: AppColors.yellow,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ReviewMacroPill(
                  label: 'Fat',
                  amount: '16 g',
                  color: AppColors.peach,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewMacroPill extends StatelessWidget {
  const _ReviewMacroPill({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 8),
        vertical: AppResponsive.value(context, 10),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              style: TextStyle(
                fontSize: AppResponsive.font(context, 15),
                fontWeight: FontWeight.w800,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 2)),
          Text(
            label,
            style: TextStyle(
              fontSize: AppResponsive.font(context, 10),
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmSaveButton extends StatelessWidget {
  const _ConfirmSaveButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppResponsive.value(context, 50),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, 18),
          ),
          shape: const StadiumBorder(),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Confirm & save',
                style: TextStyle(
                  fontSize: AppResponsive.font(context, 15),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              width: AppResponsive.value(context, 32),
              height: AppResponsive.value(context, 32),
              decoration: const BoxDecoration(
                color: AppColors.lime,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.darkGreen,
                size: AppResponsive.value(context, 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
