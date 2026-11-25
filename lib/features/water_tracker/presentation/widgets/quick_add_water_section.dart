import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';

class QuickAddWaterSection extends StatelessWidget {
  const QuickAddWaterSection({
    super.key,
    required this.selectedAmountMl,
    required this.onAddWater,
  });

  final int selectedAmountMl;
  final ValueChanged<int> onAddWater;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick add',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: AppResponsive.font(context, 16),
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 10)),
        Row(
          children: [
            Expanded(
              child: _QuickAddButton(
                amountMl: 150,
                isSelected: selectedAmountMl == 150,
                onTap: () => onAddWater(150),
              ),
            ),
            SizedBox(width: AppResponsive.value(context, 10)),
            Expanded(
              child: _QuickAddButton(
                amountMl: 250,
                isSelected: selectedAmountMl == 250,
                onTap: () => onAddWater(250),
              ),
            ),
            SizedBox(width: AppResponsive.value(context, 10)),
            Expanded(
              child: _QuickAddButton(
                amountMl: 500,
                isSelected: selectedAmountMl == 500,
                onTap: () => onAddWater(500),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({
    required this.amountMl,
    required this.isSelected,
    required this.onTap,
  });

  final int amountMl;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppColors.darkGreen
        : AppColors.softGreen;
    final textColor = isSelected ? Colors.white : AppColors.darkGreen;
    final plusColor = isSelected ? AppColors.lime : AppColors.darkGreen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 16)),
        child: Ink(
          height: AppResponsive.value(context, 68),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              AppResponsive.value(context, 16),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '+',
                style: TextStyle(
                  color: plusColor,
                  fontSize: AppResponsive.font(context, 16),
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              SizedBox(height: AppResponsive.value(context, 2)),
              Text(
                '$amountMl ml',
                style: TextStyle(
                  color: textColor,
                  fontSize: AppResponsive.font(context, 13),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
