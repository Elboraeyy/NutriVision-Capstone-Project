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

/// AI Meal Plan Generator, Preview & Edit screen (Figma node 206:4892).
class AiPlanGenerateScreen extends StatefulWidget {
  const AiPlanGenerateScreen({super.key});

  @override
  State<AiPlanGenerateScreen> createState() => _AiPlanGenerateScreenState();
}

class _AiPlanGenerateScreenState extends State<AiPlanGenerateScreen> {
  int _selectedDuration = 1;
  final String _selectedGoal = 'Fat loss & muscle retain (1,850 kcal/day)';
  final String _mealPattern = '3 meals + 1 snack';
  final List<String> _pantryItems = [
    'Chicken breast',
    'Rolled oats',
    'Greek yogurt',
    'Salmon',
    'Chickpeas',
  ];

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
        final draft = state.draftPlan;
        final headerHeight = AppOverlayScaffold.contentTop(context, 100);

        return AppOverlayScaffold(
          header: MealSubHeader(
            title: 'Make room for good food.',
            subtitle: 'AI Meal Plan Generator, Preview & Edit',
            onBack: () => context.pop(),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppResponsive.value(context, 20),
              headerHeight + AppResponsive.value(context, 14),
              AppResponsive.value(context, 20),
              AppResponsive.value(context, 32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Start with you" Card
                _buildStartWithYouCard(context, state),
                SizedBox(height: AppResponsive.value(context, 24)),

                // If draft is generated, show "Make it your own" section
                if (draft != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Make it your own',
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
                          color: AppColors.softGreen,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'AI Draft ready',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: AppResponsive.font(context, 11),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),
                  ...draft.meals.map((meal) {
                    final isThisCycling =
                        state.isCyclingMeal && state.cyclingMealId == meal.id;
                    return PlannedMealCard(
                      meal: meal,
                      showActions: true,
                      isCycling: isThisCycling,
                      onCycleAlternative: () {
                        context.read<MealPlanBloc>().add(
                          MealPlanAlternativeCycled(
                            mealId: meal.id,
                            isForDraft: true,
                          ),
                        );
                      },
                      onReplaceFromDiscover: () {
                        context.pushNamed('recipe-search');
                      },
                    );
                  }),
                  SizedBox(height: AppResponsive.value(context, 18)),
                  // Draft daily totals card
                  PlannedNutritionCard(nutrition: draft.nutrition),
                  SizedBox(height: AppResponsive.value(context, 24)),
                  // Approve and save button
                  AppActionButton(
                    label: 'Approve & save plan',
                    onPressed: () {
                      context.read<MealPlanBloc>().add(MealPlanApproved(draft));
                      context.pop();
                    },
                  ),
                  SizedBox(height: AppResponsive.value(context, 32)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartWithYouCard(BuildContext context, MealPlanState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        border: Border.all(color: const Color(0xFFE5ECE0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.softGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.green,
                  size: 16,
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 8)),
              Text(
                'Start with you',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 16),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          // Goal field
          _buildFieldLabel(context, 'Primary goal & calorie target'),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.value(context, 14),
              vertical: AppResponsive.value(context, 10),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9F5),
              borderRadius: BorderRadius.circular(
                AppResponsive.value(context, 12),
              ),
              border: Border.all(color: const Color(0xFFE2EAD8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedGoal,
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: AppResponsive.font(context, 13),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.green,
                ),
              ],
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          // Duration chips
          _buildFieldLabel(context, 'Plan duration'),
          Row(
            children: [1, 3, 7].map((days) {
              final isSelected = _selectedDuration == days;
              return Padding(
                padding: EdgeInsets.only(
                  right: AppResponsive.value(context, 8),
                ),
                child: ChoiceChip(
                  label: Text('$days ${days == 1 ? "day" : "days"}'),
                  selected: isSelected,
                  selectedColor: AppColors.green,
                  backgroundColor: const Color(0xFFF7F9F5),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.darkGreen,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: AppResponsive.font(context, 12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.green
                          : const Color(0xFFE2EAD8),
                    ),
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedDuration = days);
                  },
                ),
              );
            }).toList(),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          // Meal pattern & Dietary preferences
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(context, 'Meal pattern'),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.value(context, 12),
                        vertical: AppResponsive.value(context, 9),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2EAD8)),
                      ),
                      child: Text(
                        _mealPattern,
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: AppResponsive.font(context, 12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel(context, 'Diet preference'),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.value(context, 12),
                        vertical: AppResponsive.value(context, 9),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2EAD8)),
                      ),
                      child: Text(
                        'High protein',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: AppResponsive.font(context, 12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          // Available pantry items
          _buildFieldLabel(context, 'Available in your kitchen / pantry'),
          Wrap(
            spacing: AppResponsive.value(context, 6),
            runSpacing: AppResponsive.value(context, 6),
            children: _pantryItems.map((item) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 10),
                  vertical: AppResponsive.value(context, 5),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E8D6),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          // Allergy badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.value(context, 12),
              vertical: AppResponsive.value(context, 8),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF3EC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF4DEC9)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFFC76D28),
                  size: 16,
                ),
                SizedBox(width: AppResponsive.value(context, 8)),
                Expanded(
                  child: Text(
                    'Peanut allergy · Auto-enforced from your profile',
                    style: TextStyle(
                      color: const Color(0xFF8C4710),
                      fontSize: AppResponsive.font(context, 11),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 18)),
          // Generate button
          AppActionButton(
            label: state.isGeneratingAi
                ? 'Generating tailored plan...'
                : 'Generate draft plan',
            onPressed: state.isGeneratingAi
                ? null
                : () {
                    context.read<MealPlanBloc>().add(
                      MealPlanAiGenerationRequested(
                        goal: _selectedGoal,
                        durationDays: _selectedDuration,
                        availableFoods: _pantryItems,
                        mealPattern: _mealPattern,
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppResponsive.value(context, 6)),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.darkGreen.withValues(alpha: 0.7),
          fontSize: AppResponsive.font(context, 12),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
