import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';

class AuthActionButton extends StatelessWidget {
  const AuthActionButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scale = AppResponsive.scale(context);

    return SizedBox(
      height: AppResponsive.value(context, 58),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.lime,
          padding: EdgeInsets.only(
            left: AppResponsive.value(context, 20),
            right: AppResponsive.value(context, 8),
          ),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppResponsive.font(context, 16),
                fontWeight: FontWeight.w800,
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.lime,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: AppResponsive.value(context, 42),
                height: AppResponsive.value(context, 42),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.green,
                  size: 20 * scale,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
