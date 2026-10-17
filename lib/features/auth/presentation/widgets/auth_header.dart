import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/design_status_bar.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scale = AppResponsive.scale(context);

    return Container(
      height: AppResponsive.value(context, 185),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 16),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 46)),
          bottomRight: Radius.circular(AppResponsive.value(context, 46)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppResponsive.value(context, 38),
            child: const DesignStatusBar(
              assetPath: AppAssets.welcomeDeviceStatus,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/welcome');
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppResponsive.value(context, 7),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, color: Colors.white, size: 17 * scale),
                  SizedBox(width: AppResponsive.value(context, 5)),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppResponsive.font(context, 11),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 5)),
          Text(
            'YOUR ACCOUNT',
            style: TextStyle(
              color: AppColors.lime,
              fontSize: AppResponsive.font(context, 10),
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 7)),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.font(context, 27),
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 8)),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: AppResponsive.font(context, 11),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
