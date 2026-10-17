import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.onToggleObscure,
    this.suffixIcon,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 37,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            cursorColor: AppColors.green,
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: AppColors.mutedGreen,
                fontSize: 11,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIcon:
                  suffixIcon ??
                  (onToggleObscure == null
                      ? null
                      : IconButton(
                          onPressed: onToggleObscure,
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.green,
                            size: 17,
                          ),
                        )),
              filled: true,
              fillColor: const Color(0xFFEFF2E5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderGreen),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.green),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
