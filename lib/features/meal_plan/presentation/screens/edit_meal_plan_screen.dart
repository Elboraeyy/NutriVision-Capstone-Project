import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_action_button.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../bloc/meal_plan_bloc.dart';
import '../widgets/meal_plan_widgets.dart';

/// Edit Meal Plan Screen matching Figma node 206:5118.
class EditMealPlanScreen extends StatelessWidget {
  const EditMealPlanScreen({super.key});

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

        return AppOverlayScaffold(
          header: MealSubHeader(
            title: 'A good day ahead.',
            subtitle: plan != null
                ? '${plan.formattedDate} · 4 planned meals'
                : 'Editing your daily plan',
            onBack: () => context.pop(),
          ),
          body: plan == null
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.green),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.value(context, 20),
                    vertical: AppResponsive.value(context, 16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlannedNutritionCard(nutrition: plan.nutrition),
                      SizedBox(height: AppResponsive.value(context, 24)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'On your menu',
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: AppResponsive.font(context, 18),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppResponsive.value(context, 10),
                              vertical: AppResponsive.value(context, 4),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDF0E1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Tap swap to cycle',
                              style: TextStyle(
                                color: AppColors.green,
                                fontSize: AppResponsive.font(context, 11),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppResponsive.value(context, 14)),
                      ...plan.meals.map((meal) {
                        final isThisCycling =
                            state.isCyclingMeal &&
                            state.cyclingMealId == meal.id;
                        return PlannedMealCard(
                          meal: meal,
                          showActions: true,
                          isCycling: isThisCycling,
                          onCycleAlternative: () {
                            context.read<MealPlanBloc>().add(
                              MealPlanAlternativeCycled(
                                mealId: meal.id,
                                isForDraft: false,
                              ),
                            );
                          },
                          onReplaceFromDiscover: () {
                            context.pushNamed('recipe-search');
                          },
                        );
                      }),
                      SizedBox(height: AppResponsive.value(context, 20)),
                      AppActionButton(
                        label: 'Save plan changes',
                        onPressed: () {
                          AppToast.show(
                            context,
                            message: 'Meal plan updated successfully!',
                            type: AppToastType.success,
                          );
                          context.pop();
                        },
                      ),
                      SizedBox(height: AppResponsive.value(context, 32)),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
