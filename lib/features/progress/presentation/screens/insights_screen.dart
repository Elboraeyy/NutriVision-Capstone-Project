import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_floating_navigation_bar.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/entities/nutrient_comparison.dart';
import '../bloc/progress_bloc.dart';
import '../widgets/progress_widgets.dart';

/// Detailed Insights screen matching Figma node 206:6202.
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  void _openRangePicker(BuildContext context, ProgressRange current) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppResponsive.value(context, 28)),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppResponsive.value(context, 20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select date range',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 18),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 12)),
                ...ProgressRange.values.map((range) {
                  final selected = range == current;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppResponsive.value(context, 8),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: selected
                              ? AppColors.green
                              : AppColors.softGreen,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      tileColor: selected ? AppColors.softGreen : Colors.white,
                      leading: Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.green,
                        size: AppResponsive.value(context, 18),
                      ),
                      title: Text(
                        range.title,
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: AppResponsive.font(context, 14),
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                      ),
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.green,
                            )
                          : null,
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        context.read<ProgressBloc>().add(
                          ProgressRangeChanged(range),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: BlocConsumer<ProgressBloc, ProgressState>(
        listener: (context, state) {
          if (state.status == ProgressStatus.failure &&
              state.errorMessage != null) {
            AppToast.show(
              context,
              message: state.errorMessage!,
              type: AppToastType.error,
            );
          }
        },
        builder: (context, state) {
          final snapshot = state.snapshot;
          final headerHeight = AppOverlayScaffold.contentTop(context, 150);
          final overlap = AppResponsive.value(context, 24);
          final selectorHeight = AppResponsive.value(context, 48);

          return AppOverlayScaffold(
            header: ProgressHeader(
              title: 'Insights',
              subtitle: 'Patterns and actionable suggestions.',
              showBack: true,
              onBackTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/progress');
                }
              },
              onProfileTap: () => context.pushNamed('profile'),
            ),
            body: snapshot == null
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.green),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppResponsive.value(context, 20),
                      headerHeight +
                          selectorHeight -
                          overlap +
                          AppResponsive.value(context, 14),
                      AppResponsive.value(context, 20),
                      AppResponsive.value(context, 110),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InsightComparisonCard(snapshot: snapshot),
                        SizedBox(height: AppResponsive.value(context, 16)),
                        InsightSuggestionCard(
                          suggestion: snapshot.suggestion,
                          onActionTap: () => context.pushNamed(
                            snapshot.suggestion.targetRouteName,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 16)),
                        PatternsStatusCard(pattern: snapshot.pattern),
                        SizedBox(height: AppResponsive.value(context, 16)),
                        TransparencyNote(
                          title: snapshot.transparencyTitle,
                          description: snapshot.transparencyDescription,
                        ),
                      ],
                    ),
                  ),
            foregrounds: [
              Positioned(
                top: headerHeight - overlap,
                left: AppResponsive.value(context, 20),
                right: AppResponsive.value(context, 20),
                child: DateRangeSelectorPill(
                  selectedRange: state.selectedRange,
                  onTap: () => _openRangePicker(context, state.selectedRange),
                ),
              ),
              Positioned(
                left: AppResponsive.value(context, 14),
                right: AppResponsive.value(context, 14),
                bottom: AppResponsive.value(context, 8),
                child: AppFloatingNavigationBar(
                  selectedIndex: 3,
                  onSelected: (index) {
                    switch (index) {
                      case 0:
                        context.go('/home');
                        break;
                      case 1:
                        context.go('/meal-plan');
                        break;
                      case 2:
                        context.go('/discover');
                        break;
                      case 3:
                        context.go('/progress');
                        break;
                      case 4:
                        context.go('/profile');
                        break;
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
