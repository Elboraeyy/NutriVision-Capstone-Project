import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../widgets/camera_scanner_widgets.dart';

/// Thin route screen for scanning a meal using the camera or gallery.
class CameraScannerScreen extends StatelessWidget {
  const CameraScannerScreen({
    super.key,
    this.onBack,
    this.onChoosePhoto,
    this.onTakePhoto,
  });

  final VoidCallback? onBack;
  final VoidCallback? onChoosePhoto;
  final VoidCallback? onTakePhoto;

  static const double _headerHeight = 165;

  void _openAnalyzing(BuildContext context) {
    GoRouter.maybeOf(context)?.pushNamed('meal-analyzing');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: CameraScannerHeader(
          headerHeight: _headerHeight,
          onBack: onBack ?? () => Navigator.maybePop(context),
        ),
        body: _CameraScannerBody(
          headerHeight: _headerHeight,
          onChoosePhoto: onChoosePhoto ?? () => _openAnalyzing(context),
          onTakePhoto: onTakePhoto ?? () => _openAnalyzing(context),
        ),
      ),
    );
  }
}

class _CameraScannerBody extends StatelessWidget {
  const _CameraScannerBody({
    required this.headerHeight,
    required this.onChoosePhoto,
    required this.onTakePhoto,
  });

  final double headerHeight;
  final VoidCallback onChoosePhoto;
  final VoidCallback onTakePhoto;

  @override
  Widget build(BuildContext context) {
    final topPadding =
        AppOverlayScaffold.contentTop(context, headerHeight) +
        AppResponsive.value(context, 14);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 18),
        topPadding,
        AppResponsive.value(context, 18),
        AppResponsive.value(context, 32),
      ),
      child: Column(
        children: [
          const ScannerViewfinder(),
          SizedBox(height: AppResponsive.value(context, 20)),
          Text(
            'Keep the whole meal in view',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 18),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'Good light helps us estimate portions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 13),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 24)),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    AppResponsive.value(context, 20),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      AppResponsive.value(context, 20),
                    ),
                    onTap: onChoosePhoto,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppResponsive.value(context, 16),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppResponsive.value(context, 20),
                        ),
                        border: Border.all(
                          color: AppColors.softGreen,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: AppResponsive.value(context, 26),
                            color: AppColors.darkGreen,
                          ),
                          SizedBox(height: AppResponsive.value(context, 8)),
                          Text(
                            'Choose photo',
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: AppResponsive.font(context, 13),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 12)),
              Expanded(
                child: Material(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(
                    AppResponsive.value(context, 20),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      AppResponsive.value(context, 20),
                    ),
                    onTap: onTakePhoto,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppResponsive.value(context, 16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: AppResponsive.value(context, 26),
                            color: AppColors.lime,
                          ),
                          SizedBox(height: AppResponsive.value(context, 8)),
                          Text(
                            'Take photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppResponsive.font(context, 13),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 20)),
          Text(
            "You'll review everything before saving.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
            ),
          ),
        ],
      ),
    );
  }
}
