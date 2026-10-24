import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AuthUnderlinedText extends StatelessWidget {
  const AuthUnderlinedText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppColors.errorRed,
              fontFamily: 'serif',
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Container(height: 1.2, color: AppColors.errorRed),
        ],
      ),
    );
  }
}
