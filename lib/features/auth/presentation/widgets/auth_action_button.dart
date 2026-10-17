import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AuthActionButton extends StatelessWidget {
  const AuthActionButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.lime,
          padding: const EdgeInsets.only(left: 20, right: 8),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.lime,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.green,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
