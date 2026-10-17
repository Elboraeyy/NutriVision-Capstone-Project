import 'package:flutter/services.dart';

import 'app_colors.dart';

abstract final class AppSystemUi {
  static const greenHeader = SystemUiOverlayStyle(
    statusBarColor: AppColors.green,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.cream,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: AppColors.cream,
  );

  static const greenScreen = SystemUiOverlayStyle(
    statusBarColor: AppColors.green,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.green,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: AppColors.green,
  );
}
