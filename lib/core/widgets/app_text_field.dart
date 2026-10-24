import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_responsive.dart';

/// Shared styled text field used by forms throughout the app.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.onToggleObscure,
    this.suffixIcon,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final scale = AppResponsive.scale(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: AppResponsive.font(context, 13.5),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 4)),
        SizedBox(
          height: AppResponsive.value(context, 64),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            obscureText: obscureText,
            cursorColor: AppColors.green,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 15.5),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.mutedGreen,
                fontSize: AppResponsive.font(context, 15.5),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppResponsive.value(context, 17),
              ),
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
                            size: 21 * scale,
                          ),
                        )),
              filled: true,
              fillColor: const Color(0xFFEFF2E5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppResponsive.value(context, 18),
                ),
                borderSide: const BorderSide(color: AppColors.borderGreen),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppResponsive.value(context, 18),
                ),
                borderSide: const BorderSide(color: AppColors.green),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
