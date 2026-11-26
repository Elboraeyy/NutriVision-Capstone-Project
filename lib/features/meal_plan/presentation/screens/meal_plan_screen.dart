import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_floating_navigation_bar.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../bloc/meal_plan_bloc.dart';
import '../widgets/meal_plan_widgets.dart';

/// Main Meal Plan screen (Figma node 206:5249).
class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealPlanBloc, MealPlanState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppToast.show(
            context,
            message: state.errorMessage!,
            type: AppToastType.error,
          );
        } else if (state.feedbackMessage != null) {
          AppToast.show(
            context,
            message: state.feedbackMessage!,
            type: AppToastType.success,
          );
        }
      },
      builder: (context, state) {
        final plan = state.activePlan;
        final selectedDate = state.selectedDate;
        final headerHeight = AppOverlayScaffold.contentTop(context, 155);
        final overlap = AppResponsive.value(context, 40);

        return AppOverlayScaffold(
          header: MealPlanHeader(
            dateText: plan?.formattedDate ?? 'Today',
            isToday: plan?.isToday ?? true,
            statusNote: plan?.statusNote ?? '4 planned meals · Not logged',
            onPreviousDate: () {
              final prev = selectedDate.subtract(const Duration(days: 1));
              context.read<MealPlanBloc>().add(MealPlanDateChanged(prev));
            },
            onNextDate: () {
              final next = selectedDate.add(const Duration(days: 1));
              context.read<MealPlanBloc>().add(MealPlanDateChanged(next));
            },
            onGeneratePlan: () {
              context.pushNamed('ai-plan-generate');
            },
          ),
          body: plan == null
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: AppColors.green),
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppResponsive.value(context, 20),
                    headerHeight + AppResponsive.value(context, 215),
                    AppResponsive.value(context, 20),
                    AppResponsive.value(context, 110),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section header: Day's meals + Edit plan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${plan.formattedDate.split(',').first}'s meals",
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: AppResponsive.font(context, 18),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          InkWell(
                            onTap: () => context.pushNamed('edit-meal-plan'),
                            borderRadius: BorderRadius.circular(100),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppResponsive.value(context, 8),
                                vertical: AppResponsive.value(context, 4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Edit plan',
                                    style: TextStyle(
                                      color: AppColors.green,
                                      fontSize: AppResponsive.font(context, 13),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: AppResponsive.value(context, 4),
                                  ),
                                  Icon(
                                    Icons.arrow_outward_rounded,
                                    size: AppResponsive.value(context, 14),
                                    color: AppColors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppResponsive.value(context, 14)),
                      ...plan.meals.map((meal) {
                        return PlannedMealCard(
                          meal: meal,
                          onTap: () => context.pushNamed('edit-meal-plan'),
                        );
                      }),
                      SizedBox(height: AppResponsive.value(context, 12)),
                      // Bottom encouragement banner
                      Container(
                        padding: EdgeInsets.all(
                          AppResponsive.value(context, 14),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF0E1),
                          borderRadius: BorderRadius.circular(
                            AppResponsive.value(context, 16),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.tips_and_updates_rounded,
                              color: AppColors.green,
                              size: 20,
                            ),
                            SizedBox(width: AppResponsive.value(context, 10)),
                            Expanded(
                              child: Text(
                                'Planning ahead reduces unneeded snacking by 42%. Tap "Generate plan" to refresh anytime.',
                                style: TextStyle(
                                  color: AppColors.darkGreen.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: AppResponsive.font(context, 11),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          foregrounds: [
            if (plan != null)
              Positioned(
                top: headerHeight - overlap,
                left: AppResponsive.value(context, 20),
                right: AppResponsive.value(context, 20),
                child: PlannedNutritionCard(nutrition: plan.nutrition),
              ),
            Positioned(
              left: AppResponsive.value(context, 14),
              right: AppResponsive.value(context, 14),
              bottom: AppResponsive.value(context, 8),
              child: AppFloatingNavigationBar(
                selectedIndex: 1,
                onSelected: (index) {
                  switch (index) {
                    case 0:
                      context.go('/home');
                      break;
                    case 1:
                      break;
                    case 2:
                      context.go('/discover');
                      break;
                    case 3:
                      context.go('/water-tracker');
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
    );
  }
}
