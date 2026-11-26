import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../domain/entities/insight_summary.dart';
import '../../domain/entities/nutrient_comparison.dart';
import '../../domain/entities/progress_snapshot.dart';
import '../../domain/entities/weekly_nutrient_day.dart';

/// Curved forest-green header used across Progress & Insights screens.
class ProgressHeader extends StatelessWidget {
  const ProgressHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBack = false,
    this.onBackTap,
    this.onProfileTap,
  });

  final String title;
  final String subtitle;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 20),
        topInset + AppResponsive.value(context, 14),
        AppResponsive.value(context, 20),
        AppResponsive.value(context, 42),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 40)),
          bottomRight: Radius.circular(AppResponsive.value(context, 40)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBack)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
                    borderRadius: BorderRadius.circular(100),
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
                )
              else
                Text(
                  'NutriVision',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppResponsive.font(context, 14),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              InkWell(
                onTap: onProfileTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: AppResponsive.value(context, 38),
                  height: AppResponsive.value(context, 38),
                  decoration: BoxDecoration(
                    color: AppColors.peach,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.green,
                    size: AppResponsive.value(context, 20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppResponsive.font(context, 26),
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 4)),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.softGreen,
                    fontSize: AppResponsive.font(context, 12),
                    fontWeight: FontWeight.w500,
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

/// Floating daily nutrition card overlapping the curved green header on Progress.
class DailyIntakeFloatingCard extends StatelessWidget {
  const DailyIntakeFloatingCard({super.key, required this.snapshot});

  final ProgressSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final comparisons = snapshot.comparisons;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 16)),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF0E1),
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.dailyTitle,
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: AppResponsive.font(context, 16),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: AppResponsive.value(context, 2)),
                    Text(
                      snapshot.dateAndSourceLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.mutedGreen,
                        fontSize: AppResponsive.font(context, 10.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 10),
                  vertical: AppResponsive.value(context, 5),
                ),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  snapshot.statusChipLabel,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 10.5),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          if (comparisons.length >= 4)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _CompactNutrientTile(
                        comparison: comparisons[0],
                        barColor: AppColors.green,
                      ),
                    ),
                    SizedBox(width: AppResponsive.value(context, 8)),
                    Expanded(
                      child: _CompactNutrientTile(
                        comparison: comparisons[1],
                        barColor: AppColors.lime,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.value(context, 8)),
                Row(
                  children: [
                    Expanded(
                      child: _CompactNutrientTile(
                        comparison: comparisons[2],
                        barColor: const Color(0xFF6A9B76),
                      ),
                    ),
                    SizedBox(width: AppResponsive.value(context, 8)),
                    Expanded(
                      child: _CompactNutrientTile(
                        comparison: comparisons[3],
                        barColor: const Color(0xFFD98C52),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          SizedBox(height: AppResponsive.value(context, 8)),
          Text(
            snapshot.estimateDisclosure,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 10),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactNutrientTile extends StatelessWidget {
  const _CompactNutrientTile({
    required this.comparison,
    required this.barColor,
  });

  final NutrientComparison comparison;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 10),
        vertical: AppResponsive.value(context, 8),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  comparison.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 10),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${comparison.percentage}%',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 10),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 3)),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${comparison.consumed}',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ' / ${comparison.target} ${comparison.unit}',
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 5)),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: comparison.progress,
              minHeight: AppResponsive.value(context, 5),
              backgroundColor: AppColors.softGreen,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// Weekly nutrition breakdown matching Figma node 185:1735.
class WeeklyNutritionCard extends StatelessWidget {
  const WeeklyNutritionCard({super.key, required this.snapshot});

  final ProgressSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final days = snapshot.weeklyDays;
    final comparisons = snapshot.comparisons;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        border: Border.all(color: AppColors.softGreen, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.04),
            blurRadius: 14,
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
              Expanded(
                child: Text(
                  'This week',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 17),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Flexible(
                child: Text(
                  snapshot.weekRangeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          // Day header row
          Row(
            children: [
              SizedBox(
                width: AppResponsive.value(context, 78),
                child: Text(
                  'Nutrient',
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 10.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...days
                  .where((d) => !d.isToday)
                  .map(
                    (day) => Expanded(
                      child: Text(
                        day.shortDay,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.mutedGreen,
                          fontSize: AppResponsive.font(context, 10.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              SizedBox(
                width: AppResponsive.value(context, 84),
                child: Text(
                  'Today',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: AppResponsive.font(context, 10.5),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          ...comparisons.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final colors = [
              AppColors.green,
              AppColors.lime,
              const Color(0xFF6A9B76),
              const Color(0xFFD98C52),
            ];
            return Padding(
              padding: EdgeInsets.only(
                bottom: idx == comparisons.length - 1
                    ? 0
                    : AppResponsive.value(context, 14),
              ),
              child: _WeeklyNutrientRow(
                comparison: item,
                days: days,
                accentColor: colors[idx % colors.length],
              ),
            );
          }),
          SizedBox(height: AppResponsive.value(context, 14)),
          Text(
            snapshot.missingDataLegend,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 10.5),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyNutrientRow extends StatelessWidget {
  const _WeeklyNutrientRow({
    required this.comparison,
    required this.days,
    required this.accentColor,
  });

  final NutrientComparison comparison;
  final List<WeeklyNutrientDay> days;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final priorDays = days.where((d) => !d.isToday).toList();
    final todayDay = days.lastWhere(
      (d) => d.isToday,
      orElse: () => const WeeklyNutrientDay(
        shortDay: 'Today',
        isToday: true,
        hasData: false,
      ),
    );
    final todayVal = todayDay.valueForNutrient(comparison.id);
    final todayProgress = comparison.target <= 0
        ? 0.0
        : (todayVal / comparison.target).clamp(0.0, 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: AppResponsive.value(context, 78),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comparison.id == 'carbs' ? 'Carbs' : comparison.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 12),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${comparison.target} ${comparison.unit}',
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 10),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ...priorDays.map((day) {
          if (!day.hasData) {
            return Expanded(
              child: Text(
                '—',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.mutedGreen.withValues(alpha: 0.65),
                  fontSize: AppResponsive.font(context, 12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          final val = day.valueForNutrient(comparison.id);
          final ratio = comparison.target <= 0
              ? 0.0
              : (val / comparison.target).clamp(0.15, 1.0);
          return Expanded(
            child: Center(
              child: Container(
                width: AppResponsive.value(context, 6),
                height: AppResponsive.value(context, 22),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: FractionallySizedBox(
                  heightFactor: ratio,
                  child: Container(
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        SizedBox(
          width: AppResponsive.value(context, 84),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$todayVal ${comparison.unit}',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 11.5),
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: AppResponsive.value(context, 4)),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: todayProgress,
                  minHeight: AppResponsive.value(context, 4.5),
                  backgroundColor: AppColors.softGreen,
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Interactive row/card navigating from Progress to Insights (Figma 185:1805).
class InsightsLinkCard extends StatelessWidget {
  const InsightsLinkCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.green,
      borderRadius: BorderRadius.circular(AppResponsive.value(context, 22)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 22)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, 18),
            vertical: AppResponsive.value(context, 16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppResponsive.font(context, 15),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: AppResponsive.value(context, 3)),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.softGreen,
                        fontSize: AppResponsive.font(context, 11.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 12)),
              Container(
                width: AppResponsive.value(context, 36),
                height: AppResponsive.value(context, 36),
                decoration: const BoxDecoration(
                  color: AppColors.lime,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: AppColors.darkGreen,
                  size: AppResponsive.value(context, 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating date range selector pill on InsightsScreen (Figma 185:1588).
class DateRangeSelectorPill extends StatelessWidget {
  const DateRangeSelectorPill({
    super.key,
    required this.selectedRange,
    required this.onTap,
  });

  final ProgressRange selectedRange;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
      elevation: 4,
      shadowColor: AppColors.darkGreen.withValues(alpha: 0.10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: AppResponsive.value(context, 48),
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, 16),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.softGreen, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: AppColors.green,
                size: AppResponsive.value(context, 17),
              ),
              Expanded(
                child: Text(
                  selectedRange.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13.5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.green,
                size: AppResponsive.value(context, 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detailed comparison card on InsightsScreen (Figma 185:1594).
class InsightComparisonCard extends StatelessWidget {
  const InsightComparisonCard({super.key, required this.snapshot});

  final ProgressSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final barColors = [
      AppColors.green,
      AppColors.lime,
      const Color(0xFF6A9B76),
      const Color(0xFFD98C52),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        border: Border.all(color: AppColors.softGreen, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.04),
            blurRadius: 14,
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
              Expanded(
                child: Text(
                  'Nutrition comparisons',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 17),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 10),
                  vertical: AppResponsive.value(context, 5),
                ),
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  snapshot.statusChipLabel,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 11),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Text(
            snapshot.dataScopeLabel,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.4,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          ...snapshot.comparisons.asMap().entries.map((entry) {
            final idx = entry.key;
            final c = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: idx == snapshot.comparisons.length - 1
                    ? 0
                    : AppResponsive.value(context, 14),
              ),
              child: _FullComparisonBar(
                comparison: c,
                color: barColors[idx % barColors.length],
              ),
            );
          }),
          SizedBox(height: AppResponsive.value(context, 14)),
          Text(
            snapshot.chartExplanation,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 11),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullComparisonBar extends StatelessWidget {
  const _FullComparisonBar({required this.comparison, required this.color});

  final NutrientComparison comparison;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              comparison.label,
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: AppResponsive.font(context, 13.5),
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              comparison.loggedDisplay,
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: AppResponsive.font(context, 12.5),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.value(context, 6)),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: comparison.progress,
            minHeight: AppResponsive.value(context, 7),
            backgroundColor: AppColors.softGreen,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              comparison.scaleOriginLabel,
              style: TextStyle(
                color: AppColors.mutedGreen,
                fontSize: AppResponsive.font(context, 10.5),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              comparison.targetDisplay,
              style: TextStyle(
                color: AppColors.mutedGreen,
                fontSize: AppResponsive.font(context, 10.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Actionable suggestion card on InsightsScreen (Figma 185:1637).
class InsightSuggestionCard extends StatelessWidget {
  const InsightSuggestionCard({
    super.key,
    required this.suggestion,
    required this.onActionTap,
  });

  final InsightSuggestion suggestion;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: AppColors.yellow.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        border: Border.all(
          color: AppColors.lime.withValues(alpha: 0.6),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.green,
                size: AppResponsive.value(context, 18),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Text(
                suggestion.categoryLabel,
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: AppResponsive.font(context, 11),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 8)),
          Text(
            suggestion.headline,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 18),
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Text(
            suggestion.description,
            style: TextStyle(
              color: AppColors.darkGreen.withValues(alpha: 0.85),
              fontSize: AppResponsive.font(context, 12.5),
              height: 1.45,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.value(context, 14),
                vertical: AppResponsive.value(context, 8),
              ),
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    suggestion.actionLabel,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppResponsive.font(context, 12),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: AppResponsive.value(context, 6)),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.lime,
                    size: AppResponsive.value(context, 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Patterns and streak coverage card on InsightsScreen (Figma 185:1644).
class PatternsStatusCard extends StatelessWidget {
  const PatternsStatusCard({super.key, required this.pattern});

  final ProgressPattern pattern;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF0E1),
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        border: Border.all(color: AppColors.softGreen, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.show_chart_rounded,
                color: AppColors.green,
                size: AppResponsive.value(context, 19),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Text(
                pattern.title,
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 16),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Text(
            pattern.coverageLabel,
            style: TextStyle(
              color: AppColors.green,
              fontSize: AppResponsive.font(context, 12),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Text(
            pattern.description,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// Transparency disclosure footer on InsightsScreen (Figma 185:1651).
class TransparencyNote extends StatelessWidget {
  const TransparencyNote({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 12.5),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            description,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 11.5),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
