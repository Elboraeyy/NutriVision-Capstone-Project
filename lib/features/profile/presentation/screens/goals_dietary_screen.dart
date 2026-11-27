import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../auth/presentation/bloc/auth_session_bloc.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../domain/entities/goals_dietary_preferences.dart';
import '../bloc/goals_dietary_bloc.dart';
import '../widgets/goals_dietary_widgets.dart';

class GoalsDietaryScreen extends StatefulWidget {
  const GoalsDietaryScreen({super.key});

  @override
  State<GoalsDietaryScreen> createState() => _GoalsDietaryScreenState();
}

class _GoalsDietaryScreenState extends State<GoalsDietaryScreen> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthSessionBloc>().state.user?.id;
    if (userId == null || userId.isEmpty) return;
    context.read<GoalsDietaryBloc>().add(GoalsDietaryStarted(userId: userId));
  }

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('profile');
    }
  }

  Future<void> _editGoal(BuildContext context, String currentGoal) async {
    final selected = await showGoalSelectionDialog(
      context,
      currentGoal: currentGoal,
    );
    if (selected == null || !context.mounted) return;
    context.read<GoalsDietaryBloc>().add(GoalPreferenceChanged(selected));
  }

  Future<void> _editAllergies(
    BuildContext context,
    List<String> currentAllergies,
  ) async {
    final updated = await showMultiSelectChipDialog(
      context,
      title: 'Edit allergies',
      subtitle:
          'Select allergens to avoid. Allergy restrictions cannot be overridden by food preferences.',
      suggestions: GoalsDietaryPreferences.commonAllergens,
      initialSelected: currentAllergies,
      customHint: 'Add allergy (e.g. Mustard)',
    );
    if (updated == null || !context.mounted) return;
    context.read<GoalsDietaryBloc>().add(AllergiesUpdated(updated));
  }

  Future<void> _editTarget(
    BuildContext context,
    DailyTargetField field,
    DailyTargets targets,
  ) async {
    final (label, unit, currentValue) = switch (field) {
      DailyTargetField.calories => ('Calories', 'kcal', targets.calories),
      DailyTargetField.protein => ('Protein', 'g', targets.protein),
      DailyTargetField.carbohydrates => (
        'Carbohydrates',
        'g',
        targets.carbohydrates,
      ),
      DailyTargetField.fat => ('Fat', 'g', targets.fat),
      DailyTargetField.water => ('Water', 'ml', targets.water),
    };

    final updated = await showDailyTargetEditDialog(
      context,
      label: label,
      unit: unit,
      initialValue: currentValue,
    );
    if (updated == null || !context.mounted) return;
    context.read<GoalsDietaryBloc>().add(
      DailyTargetUpdated(field: field, value: updated),
    );
  }

  Future<void> _editExcludedIngredients(
    BuildContext context,
    List<String> currentExcluded,
  ) async {
    final updated = await showMultiSelectChipDialog(
      context,
      title: 'Excluded ingredients',
      subtitle:
          'Choose ingredients to filter out from recommendations. Separate from allergies.',
      suggestions: GoalsDietaryPreferences.commonExcludedIngredients,
      initialSelected: currentExcluded,
      customHint: 'Add ingredient to exclude',
    );
    if (updated == null || !context.mounted) return;
    context.read<GoalsDietaryBloc>().add(ExcludedIngredientsUpdated(updated));
  }

  Future<void> _editLikedFoods(
    BuildContext context,
    GoalsDietaryPreferences draft,
  ) async {
    final updated = await showMultiSelectChipDialog(
      context,
      title: 'Foods you like',
      subtitle:
          'Choose favorite foods for Discover filters and AI suggestions.',
      suggestions: GoalsDietaryPreferences.commonLikedFoods,
      initialSelected: draft.likedFoods,
      customHint: 'Add a food you like',
      blockedItems: draft.allergies,
    );
    if (updated == null || !context.mounted) return;
    context.read<GoalsDietaryBloc>().add(LikedFoodsUpdated(updated));
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    if (index == 0) {
      context.read<HomeBloc>().add(const HomeTabSelected(0));
      context.goNamed('home');
      return;
    }
    if (index == 4) {
      _navigateBack(context);
      return;
    }
    AppToast.show(
      context,
      message: '${appNavigationItems[index].label} will be connected soon.',
      type: AppToastType.info,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = AppOverlayScaffold.contentTop(
      context,
      GoalsDietaryHeader.baseHeight,
    );
    final overlap = AppResponsive.value(
      context,
      GoalsDietaryHeader.overlapDepth,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: BlocConsumer<GoalsDietaryBloc, GoalsDietaryState>(
        listenWhen: (previous, current) =>
            (previous.status != current.status &&
                (current.status == GoalsDietaryStatus.saved ||
                    current.status == GoalsDietaryStatus.failure)) ||
            (previous.message != current.message &&
                current.message != null &&
                current.status == GoalsDietaryStatus.ready),
        listener: (context, state) {
          final message = state.message;
          if (message == null || message.isEmpty) return;
          final type = switch (state.status) {
            GoalsDietaryStatus.saved => AppToastType.success,
            GoalsDietaryStatus.failure => AppToastType.error,
            _ => AppToastType.info,
          };
          AppToast.show(context, message: message, type: type);
        },
        builder: (context, state) {
          if (state.status == GoalsDietaryStatus.loading ||
              state.status == GoalsDietaryStatus.initial) {
            return AppOverlayScaffold(
              header: GoalsDietaryHeader(onBack: () => _navigateBack(context)),
              body: const Center(
                child: CircularProgressIndicator(color: AppColors.green),
              ),
            );
          }

          final draft = state.draftPreferences;
          final statusText = state.hasUnsavedChanges
              ? 'Unsaved draft changes · Tap Save changes to keep'
              : 'Current saved settings · Save only after editing';

          return AppOverlayScaffold(
            header: GoalsDietaryHeader(onBack: () => _navigateBack(context)),
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: headerHeight - overlap),
                          child: Stack(
                            children: [
                              Container(
                                height: overlap * 2,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                      AppResponsive.value(context, 38),
                                    ),
                                    bottomRight: Radius.circular(
                                      AppResponsive.value(context, 38),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  AppResponsive.value(context, 20),
                                  overlap,
                                  AppResponsive.value(context, 20),
                                  0,
                                ),
                                child: YourGoalCard(
                                  goal: draft.goal,
                                  onEdit: () => _editGoal(context, draft.goal),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppResponsive.value(context, 20),
                          AppResponsive.value(context, 16),
                          AppResponsive.value(context, 20),
                          AppResponsive.value(context, 96),
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            AllergiesCard(
                              allergies: draft.allergies,
                              onEditAllergies: () =>
                                  _editAllergies(context, draft.allergies),
                            ),
                            SizedBox(height: AppResponsive.value(context, 16)),
                            DailyTargetsCard(
                              targets: draft.dailyTargets,
                              onEditTarget: (field) => _editTarget(
                                context,
                                field,
                                draft.dailyTargets,
                              ),
                            ),
                            SizedBox(height: AppResponsive.value(context, 16)),
                            DietaryPatternCard(
                              selectedPattern: draft.dietaryPattern,
                              onPatternChanged: (pattern) => context
                                  .read<GoalsDietaryBloc>()
                                  .add(DietaryPatternChanged(pattern)),
                            ),
                            SizedBox(height: AppResponsive.value(context, 16)),
                            FoodPreferencesCard(
                              excludedIngredients: draft.excludedIngredients,
                              likedFoods: draft.likedFoods,
                              onEditExcluded: () => _editExcludedIngredients(
                                context,
                                draft.excludedIngredients,
                              ),
                              onEditLiked: () =>
                                  _editLikedFoods(context, draft),
                            ),
                            SizedBox(height: AppResponsive.value(context, 18)),
                            SizedBox(
                              height: AppResponsive.value(context, 54),
                              width: double.infinity,
                              child: FilledButton(
                                key: const ValueKey('save_goals_button'),
                                onPressed:
                                    state.status == GoalsDietaryStatus.saving
                                    ? null
                                    : () => context
                                          .read<GoalsDietaryBloc>()
                                          .add(const GoalsDietarySaved()),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppResponsive.value(
                                      context,
                                      18,
                                    ),
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: state.status == GoalsDietaryStatus.saving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Save changes',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: AppResponsive.font(
                                                  context,
                                                  15,
                                                ),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: AppResponsive.value(
                                              context,
                                              30,
                                            ),
                                            height: AppResponsive.value(
                                              context,
                                              30,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: AppColors.lime,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: AppColors.darkGreen,
                                              size: AppResponsive.value(
                                                context,
                                                18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(height: AppResponsive.value(context, 10)),
                            SizedBox(
                              height: AppResponsive.value(context, 50),
                              width: double.infinity,
                              child: OutlinedButton(
                                key: const ValueKey('cancel_goals_button'),
                                onPressed: () => context
                                    .read<GoalsDietaryBloc>()
                                    .add(const GoalsDietaryChangesCancelled()),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.cream,
                                  foregroundColor: AppColors.darkGreen,
                                  side: const BorderSide(
                                    color: AppColors.borderGreen,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: AppResponsive.font(context, 14),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: AppResponsive.value(context, 10)),
                            Text(
                              statusText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.mutedGreen,
                                fontSize: AppResponsive.font(context, 11),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: AppResponsive.value(context, 14),
                  right: AppResponsive.value(context, 14),
                  bottom: AppResponsive.value(context, 8),
                  child: AppBottomNavBar(
                    selectedIndex: 4,
                    onSelected: (index) => _handleBottomNavTap(context, index),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
