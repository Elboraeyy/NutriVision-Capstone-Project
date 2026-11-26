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
import '../bloc/progress_bloc.dart';
import '../widgets/progress_widgets.dart';

/// Main Progress dashboard screen matching Figma node 206:6306.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

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
          final headerHeight = AppOverlayScaffold.contentTop(context, 155);
          final overlap = AppResponsive.value(context, 40);
          final floatingCardHeight = AppResponsive.value(context, 224);

          return AppOverlayScaffold(
            header: ProgressHeader(
              title: 'Progress',
              subtitle: 'Clear trends from your logged nutrition.',
              onProfileTap: () => context.pushNamed('profile'),
            ),
            body: snapshot == null
                ? Center(
                    child: state.status == ProgressStatus.failure
                        ? TextButton(
                            onPressed: () => context.read<ProgressBloc>().add(
                              const ProgressStarted(),
                            ),
                            child: const Text('Tap to retry'),
                          )
                        : const CircularProgressIndicator(
                            color: AppColors.green,
                          ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppResponsive.value(context, 20),
                      headerHeight +
                          floatingCardHeight -
                          overlap +
                          AppResponsive.value(context, 16),
                      AppResponsive.value(context, 20),
                      AppResponsive.value(context, 110),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeeklyNutritionCard(snapshot: snapshot),
                        SizedBox(height: AppResponsive.value(context, 16)),
                        InsightsLinkCard(
                          title: 'View Insights & Patterns',
                          subtitle: snapshot.suggestion.headline,
                          onTap: () => context.pushNamed('insights'),
                        ),
                      ],
                    ),
                  ),
            foregrounds: [
              if (snapshot != null)
                Positioned(
                  top: headerHeight - overlap,
                  left: AppResponsive.value(context, 20),
                  right: AppResponsive.value(context, 20),
                  child: DailyIntakeFloatingCard(snapshot: snapshot),
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
