import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../domain/entities/water_intake.dart';

class WaterProgressCard extends StatelessWidget {
  const WaterProgressCard({super.key, required this.water});

  final WaterIntake water;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final formattedConsumed = numberFormat.format(water.consumedMl);
    final formattedGoal = numberFormat.format(water.goalMl);
    final formattedRemaining = numberFormat.format(water.remainingMl);

    final percentageDisplay = water.percentage >= 100
        ? '100%'
        : '${water.percentage.toStringAsFixed(1)}%';

    final filledSegments = (water.progress * 8).round();

    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.water_drop_outlined,
                      color: AppColors.green,
                      size: 22,
                    ),
                    SizedBox(width: AppResponsive.value(context, 6)),
                    Flexible(
                      child: Text(
                        "Today's water",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: AppResponsive.font(context, 15),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 10),
                  vertical: AppResponsive.value(context, 4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(
                    AppResponsive.value(context, 14),
                  ),
                ),
                child: Text(
                  '$percentageDisplay of goal',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 11),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formattedConsumed,
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 40),
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 4)),
              Text(
                'ml',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'Consumed water · Shared with Home and Progress',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 11),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          Row(
            children: List.generate(
              8,
              (index) => Expanded(
                child: Container(
                  height: AppResponsive.value(context, 8),
                  margin: EdgeInsets.only(
                    right: index == 7 ? 0 : AppResponsive.value(context, 4),
                  ),
                  decoration: BoxDecoration(
                    color: index < filledSegments
                        ? AppColors.green
                        : AppColors.borderGreen.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 ml',
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 11),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Daily goal $formattedGoal ml',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 11),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          Text(
            '$formattedRemaining ml remaining',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 13),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
