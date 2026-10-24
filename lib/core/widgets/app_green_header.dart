import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_responsive.dart';

/// Shared green header used across the app screens.
///
/// The visual structure stays consistent while each screen can provide its
/// own title, subtitle, eyebrow, corner radius, and optional back action.
class AppGreenHeader extends StatelessWidget {
  const AppGreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.eyebrow,
    this.onBack,
    this.height = 175,
    this.cornerRadius = 52,
  });

  final String title;
  final String subtitle;
  final String? eyebrow;
  final VoidCallback? onBack;
  final double height;
  final double cornerRadius;

  @override
  Widget build(BuildContext context) {
    final scale = AppResponsive.scale(context);
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      height: AppResponsive.value(context, height) + topInset,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            AppResponsive.value(context, cornerRadius),
          ),
          bottomRight: Radius.circular(
            AppResponsive.value(context, cornerRadius),
          ),
        ),
      ),
      child: Stack(
        children: [
          if (onBack != null)
            Positioned(
              top: topInset + AppResponsive.value(context, 5),
              left: AppResponsive.value(context, 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.value(context, 8),
                      vertical: AppResponsive.value(context, 7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 22 * scale,
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
            ),
          Positioned.fill(
            top: topInset,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 22),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (eyebrow != null) ...[
                      Text(
                        eyebrow!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.lime,
                          fontSize: AppResponsive.font(context, 11),
                          fontWeight: FontWeight.w700,
                          letterSpacing: .25,
                        ),
                      ),
                      SizedBox(height: AppResponsive.value(context, 8)),
                    ],
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppResponsive.font(context, 29),
                        fontWeight: FontWeight.w800,
                        height: 1.08,
                      ),
                    ),
                    SizedBox(height: AppResponsive.value(context, 9)),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.softGreen,
                        fontSize: AppResponsive.font(context, 12),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
