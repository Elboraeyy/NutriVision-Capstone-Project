import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../domain/entities/plan_nutrition.dart';
import '../../domain/entities/planned_meal.dart';

/// Top header for the Meal Plan screen (Figma 206:5249).
class MealPlanHeader extends StatelessWidget {
  const MealPlanHeader({
    super.key,
    required this.dateText,
    required this.isToday,
    required this.statusNote,
    required this.onPreviousDate,
    required this.onNextDate,
    required this.onGeneratePlan,
  });

  final String dateText;
  final bool isToday;
  final String statusNote;
  final VoidCallback onPreviousDate;
  final VoidCallback onNextDate;
  final VoidCallback onGeneratePlan;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 44)),
          bottomRight: Radius.circular(AppResponsive.value(context, 44)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 20),
        topPadding + AppResponsive.value(context, 12),
        AppResponsive.value(context, 20),
        AppResponsive.value(context, 28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPreviousDate,
                icon: const Icon(Icons.chevron_left_rounded),
                color: Colors.white,
                iconSize: AppResponsive.value(context, 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppResponsive.font(context, 18),
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (isToday) ...[
                    SizedBox(width: AppResponsive.value(context, 8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.value(context, 8),
                        vertical: AppResponsive.value(context, 3),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'Today',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: AppResponsive.font(context, 11),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              IconButton(
                onPressed: onNextDate,
                icon: const Icon(Icons.chevron_right_rounded),
                color: Colors.white,
                iconSize: AppResponsive.value(context, 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          // Subtitle and Generate Plan Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  statusNote,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 12)),
              InkWell(
                onTap: onGeneratePlan,
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.value(context, 14),
                    vertical: AppResponsive.value(context, 9),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3C2F),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.lime.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Generate plan',
                        style: TextStyle(
                          color: AppColors.lime,
                          fontSize: AppResponsive.font(context, 12),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: AppResponsive.value(context, 6)),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.lime,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_outward_rounded,
                          size: AppResponsive.value(context, 11),
                          color: AppColors.darkGreen,
                        ),
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

/// Planned Nutrition summary card matching Figma design.
class PlannedNutritionCard extends StatelessWidget {
  const PlannedNutritionCard({super.key, required this.nutrition});

  final PlanNutrition nutrition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF0E1),
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Planned nutrition',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 16),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 8),
                  vertical: AppResponsive.value(context, 3),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Daily estimate',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: AppResponsive.font(context, 11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Text(
            nutrition.note,
            style: TextStyle(
              color: AppColors.darkGreen.withValues(alpha: 0.72),
              fontSize: AppResponsive.font(context, 12),
              height: 1.35,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${nutrition.calories}',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 26),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 4)),
              Text(
                'kcal',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: AppResponsive.font(context, 14),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Text(
                '/ ${nutrition.targetCalories} target',
                style: TextStyle(
                  color: AppColors.darkGreen.withValues(alpha: 0.6),
                  fontSize: AppResponsive.font(context, 13),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          // 3 Macro progress bars
          Row(
            children: [
              Expanded(
                child: _MacroProgressTile(
                  label: 'Protein',
                  current: '${nutrition.proteinGrams}g',
                  target: '${nutrition.targetProteinGrams}g',
                  progress: nutrition.proteinRatio,
                  barColor: AppColors.green,
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Expanded(
                child: _MacroProgressTile(
                  label: 'Carbs',
                  current: '${nutrition.carbsGrams}g',
                  target: '${nutrition.targetCarbsGrams}g',
                  progress: nutrition.carbsRatio,
                  barColor: const Color(0xFF8AA82E),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Expanded(
                child: _MacroProgressTile(
                  label: 'Fat',
                  current: '${nutrition.fatGrams}g',
                  target: '${nutrition.targetFatGrams}g',
                  progress: nutrition.fatRatio,
                  barColor: const Color(0xFFE58B58),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroProgressTile extends StatelessWidget {
  const _MacroProgressTile({
    required this.label,
    required this.current,
    required this.target,
    required this.progress,
    required this.barColor,
  });

  final String label;
  final String current;
  final String target;
  final double progress;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.darkGreen.withValues(alpha: 0.65),
              fontSize: AppResponsive.font(context, 11),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: AppResponsive.font(context, 12),
                fontWeight: FontWeight.w700,
              ),
              children: [
                TextSpan(text: current),
                TextSpan(
                  text: ' / $target',
                  style: TextStyle(
                    color: AppColors.darkGreen.withValues(alpha: 0.45),
                    fontSize: AppResponsive.font(context, 10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 8)),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE6EAE0),
              valueColor: AlwaysStoppedAnimation(barColor),
              minHeight: AppResponsive.value(context, 5),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card representing a planned meal in the day list.
class PlannedMealCard extends StatelessWidget {
  const PlannedMealCard({
    super.key,
    required this.meal,
    this.onTap,
    this.onCycleAlternative,
    this.onReplaceFromDiscover,
    this.isCycling = false,
    this.showActions = false,
  });

  final PlannedMeal meal;
  final VoidCallback? onTap;
  final VoidCallback? onCycleAlternative;
  final VoidCallback? onReplaceFromDiscover;
  final bool isCycling;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppResponsive.value(context, 14)),
      decoration: BoxDecoration(
        color: Color(meal.tileColorHex),
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppResponsive.value(context, 20)),
          child: Padding(
            padding: EdgeInsets.all(AppResponsive.value(context, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type & Time pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.value(context, 10),
                        vertical: AppResponsive.value(context, 4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '${meal.type} · ${meal.time}',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: AppResponsive.font(context, 11),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${meal.calories} kcal',
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: AppResponsive.font(context, 13),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.value(context, 10)),
                Text(
                  meal.title,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 16),
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 6)),
                // Macros
                Text(
                  '${meal.protein} Protein  ·  ${meal.carbs} Carbs  ·  ${meal.fat} Fat',
                  style: TextStyle(
                    color: AppColors.darkGreen.withValues(alpha: 0.72),
                    fontSize: AppResponsive.font(context, 12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 10)),
                // Safety badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.value(context, 10),
                    vertical: AppResponsive.value(context, 5),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.green,
                        size: AppResponsive.value(context, 14),
                      ),
                      SizedBox(width: AppResponsive.value(context, 6)),
                      Flexible(
                        child: Text(
                          meal.allergens,
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 11),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showActions) ...[
                  SizedBox(height: AppResponsive.value(context, 12)),
                  const Divider(height: 1, color: Color(0x222A5240)),
                  SizedBox(height: AppResponsive.value(context, 10)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isCycling ? null : onCycleAlternative,
                          icon: isCycling
                              ? SizedBox(
                                  width: AppResponsive.value(context, 14),
                                  height: AppResponsive.value(context, 14),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.green,
                                  ),
                                )
                              : Icon(
                                  Icons.auto_awesome_rounded,
                                  size: AppResponsive.value(context, 14),
                                  color: AppColors.green,
                                ),
                          label: Text(
                            isCycling ? 'Swapping...' : 'Swap meal',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: AppResponsive.font(context, 12),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0x332A5240)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: AppResponsive.value(context, 8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppResponsive.value(context, 8)),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReplaceFromDiscover,
                          icon: Icon(
                            Icons.search_rounded,
                            size: AppResponsive.value(context, 14),
                            color: AppColors.darkGreen,
                          ),
                          label: Text(
                            'Discover',
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: AppResponsive.font(context, 12),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0x33203E30)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: AppResponsive.value(context, 8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Generic clean screen header with back button.
class MealSubHeader extends StatelessWidget {
  const MealSubHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 38)),
          bottomRight: Radius.circular(AppResponsive.value(context, 38)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 16),
        topPadding + AppResponsive.value(context, 8),
        AppResponsive.value(context, 20),
        AppResponsive.value(context, 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack ?? () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.white,
                iconSize: AppResponsive.value(context, 24),
              ),
              SizedBox(width: AppResponsive.value(context, 4)),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppResponsive.font(context, 19),
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppResponsive.value(context, 48),
              top: AppResponsive.value(context, 2),
            ),
            child: Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: AppResponsive.font(context, 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
