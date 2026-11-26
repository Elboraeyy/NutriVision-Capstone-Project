import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_widgets.dart';

/// Goals & Dietary Preferences screen matching Figma node 206:5938.
class GoalsPreferencesScreen extends StatefulWidget {
  const GoalsPreferencesScreen({super.key});

  @override
  State<GoalsPreferencesScreen> createState() => _GoalsPreferencesScreenState();
}

class _GoalsPreferencesScreenState extends State<GoalsPreferencesScreen> {
  static const double _headerHeight = 198;

  static const List<String> _goalOptions = [
    'Lose Weight',
    'Maintain Weight',
    'Gain Weight',
    'Build Muscle',
    'Eat Healthier',
  ];

  static const List<String> _dietaryOptions = [
    'No preference',
    'Flexitarian',
    'Vegetarian',
    'Vegan',
    'Pescatarian',
  ];

  static const List<String> _allergenOptions = [
    'Peanuts',
    'Tree nuts',
    'Milk',
    'Eggs',
    'Wheat',
    'Soy',
    'Fish',
    'Shellfish',
    'Sesame',
  ];

  static const List<String> _excludedOptions = [
    'Alcohol',
    'Pork',
    'Added sugar',
    'Shellfish',
    'Spicy food',
    'Caffeine',
  ];

  static const List<String> _favoriteFoodOptions = [
    'Oats',
    'Berries',
    'Salmon',
    'Rice',
    'Lentils',
    'Avocado',
    'Chicken',
    'Greek yogurt',
  ];

  late UserProfile _draft;
  bool _hasUnsavedEdits = false;

  @override
  void initState() {
    super.initState();
    _draft = context.read<ProfileBloc>().state.profile;
  }

  void _updateDraft(UserProfile next) {
    setState(() {
      _draft = next;
      _hasUnsavedEdits = true;
    });
  }

  String _formatInt(int value) {
    final s = value.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = AppOverlayScaffold.contentTop(context, _headerHeight);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) => prev.actionNonce != curr.actionNonce,
        listener: (context, state) {
          if (state.actionStatus == ProfileActionStatus.goalsSaved) {
            setState(() {
              _draft = state.profile;
              _hasUnsavedEdits = false;
            });
            AppToast.show(
              context,
              message: state.message ?? 'Goals & preferences saved.',
              type: AppToastType.success,
            );
          } else if (state.actionStatus == ProfileActionStatus.failure &&
              state.message != null) {
            AppToast.show(
              context,
              message: state.message!,
              type: AppToastType.error,
            );
          }
        },
        builder: (context, state) {
          final targets = _draft.dailyTargets;

          return AppOverlayScaffold(
            header: ProfileHeader(
              backLabel: 'Profile & Settings',
              title: 'Goals & dietary\npreferences.',
              subtitle: 'Shape your targets and food choices.',
              height: _headerHeight,
              onBack: () => context.pop(),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppResponsive.value(context, 20),
                headerHeight + AppResponsive.value(context, 16),
                AppResponsive.value(context, 20),
                AppResponsive.value(context, 114),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Your goal
                  ProfileCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your goal',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        InkWell(
                          onTap: _pickGoal,
                          borderRadius: BorderRadius.circular(18),
                          child: Row(
                            children: [
                              Container(
                                width: AppResponsive.value(context, 36),
                                height: AppResponsive.value(context, 36),
                                decoration: const BoxDecoration(
                                  color: AppColors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.track_changes_rounded,
                                  color: Colors.white,
                                  size: AppResponsive.value(context, 18),
                                ),
                              ),
                              SizedBox(width: AppResponsive.value(context, 10)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _draft.goal,
                                      style: TextStyle(
                                        color: AppColors.darkGreen,
                                        fontSize: AppResponsive.font(
                                          context,
                                          13,
                                        ),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppResponsive.value(context, 2),
                                    ),
                                    Text(
                                      'Your primary nutrition goal',
                                      style: TextStyle(
                                        color: AppColors.mutedGreen,
                                        fontSize: AppResponsive.font(
                                          context,
                                          11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.edit_outlined,
                                color: AppColors.darkGreen,
                                size: AppResponsive.value(context, 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  // Allergies
                  ProfileCard(
                    backgroundColor: AppColors.softGreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Allergies',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        if (_draft.noAllergies || _draft.allergies.isEmpty)
                          const ProfileSelectedChip(label: 'None')
                        else
                          Wrap(
                            spacing: AppResponsive.value(context, 6),
                            runSpacing: AppResponsive.value(context, 6),
                            children: _draft.allergies
                                .map((a) => ProfileSelectedChip(label: a))
                                .toList(),
                          ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        Text(
                          'Always check ingredient lists and food labels for cross-contact risk. AI suggestions may miss trace ingredients.',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 11),
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        Material(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.circular(100),
                          child: InkWell(
                            onTap: _editAllergies,
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                minHeight: AppResponsive.value(context, 44),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: AppColors.borderGreen,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Edit allergies',
                                    style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: AppResponsive.font(context, 13),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: AppResponsive.value(context, 6),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.darkGreen,
                                    size: AppResponsive.value(context, 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  // Daily targets
                  ProfileCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your daily targets',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        Text(
                          'These targets shape future meal plans and AI recommendations. Editing and saving here does not alter already-logged entries or saved plans (those will be flagged for review).',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        ProfileTargetFieldRow(
                          label: 'Calories',
                          valueText: _formatInt(targets.calories),
                          unit: 'kcal',
                          pillColor: kProfileCardSurface,
                          onTap: () => _editTarget(
                            label: 'Calories',
                            unit: 'kcal',
                            initialValue: targets.calories,
                            onSaved: (val) => _updateDraft(
                              _draft.copyWith(
                                dailyTargets: targets.copyWith(calories: val),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        ProfileTargetFieldRow(
                          label: 'Protein',
                          valueText: '${targets.proteinGrams}',
                          unit: 'g',
                          pillColor: AppColors.softGreen,
                          onTap: () => _editTarget(
                            label: 'Protein',
                            unit: 'g',
                            initialValue: targets.proteinGrams,
                            onSaved: (val) => _updateDraft(
                              _draft.copyWith(
                                dailyTargets: targets.copyWith(
                                  proteinGrams: val,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        ProfileTargetFieldRow(
                          label: 'Carbohydrates',
                          valueText: '${targets.carbsGrams}',
                          unit: 'g',
                          pillColor: AppColors.yellow,
                          onTap: () => _editTarget(
                            label: 'Carbohydrates',
                            unit: 'g',
                            initialValue: targets.carbsGrams,
                            onSaved: (val) => _updateDraft(
                              _draft.copyWith(
                                dailyTargets: targets.copyWith(carbsGrams: val),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        ProfileTargetFieldRow(
                          label: 'Fat',
                          valueText: '${targets.fatGrams}',
                          unit: 'g',
                          pillColor: AppColors.peach,
                          onTap: () => _editTarget(
                            label: 'Fat',
                            unit: 'g',
                            initialValue: targets.fatGrams,
                            onSaved: (val) => _updateDraft(
                              _draft.copyWith(
                                dailyTargets: targets.copyWith(fatGrams: val),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        ProfileTargetFieldRow(
                          label: 'Water',
                          valueText: _formatInt(targets.waterMl),
                          unit: 'ml',
                          pillColor: AppColors.softGreen,
                          onTap: () => _editTarget(
                            label: 'Water',
                            unit: 'ml',
                            initialValue: targets.waterMl,
                            onSaved: (val) => _updateDraft(
                              _draft.copyWith(
                                dailyTargets: targets.copyWith(waterMl: val),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  // Dietary pattern
                  ProfileCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dietary pattern',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        ProfileSettingsOptionRow(
                          title: _draft.dietaryPattern,
                          subtitle: 'Saved from onboarding · Tap to change',
                          trailing: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.darkGreen,
                            size: AppResponsive.value(context, 20),
                          ),
                          onTap: _pickDietaryPattern,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),

                  // Food preferences
                  ProfileCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Food preferences',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        InkWell(
                          onTap: () => _editMultiChipList(
                            title: 'Excluded ingredients',
                            options: _excludedOptions,
                            current: _draft.excludedIngredients,
                            onApply: (next) => _updateDraft(
                              _draft.copyWith(excludedIngredients: next),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Excluded ingredients',
                                      style: TextStyle(
                                        color: AppColors.darkGreen,
                                        fontSize: AppResponsive.font(
                                          context,
                                          13,
                                        ),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppResponsive.value(context, 6),
                                    ),
                                    if (_draft.excludedIngredients.isEmpty)
                                      Text(
                                        'None selected',
                                        style: TextStyle(
                                          color: AppColors.mutedGreen,
                                          fontSize: AppResponsive.font(
                                            context,
                                            11,
                                          ),
                                        ),
                                      )
                                    else
                                      Wrap(
                                        spacing: AppResponsive.value(
                                          context,
                                          6,
                                        ),
                                        runSpacing: AppResponsive.value(
                                          context,
                                          6,
                                        ),
                                        children: _draft.excludedIngredients
                                            .map(
                                              (item) => ProfileSelectedChip(
                                                label: item,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.edit_outlined,
                                color: AppColors.darkGreen,
                                size: AppResponsive.value(context, 16),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        const ProfileDivider(),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        InkWell(
                          onTap: () => _editMultiChipList(
                            title: 'Foods you like',
                            options: _favoriteFoodOptions,
                            current: _draft.favoriteFoods,
                            onApply: (next) => _updateDraft(
                              _draft.copyWith(favoriteFoods: next),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Foods you like',
                                      style: TextStyle(
                                        color: AppColors.darkGreen,
                                        fontSize: AppResponsive.font(
                                          context,
                                          13,
                                        ),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppResponsive.value(context, 6),
                                    ),
                                    if (_draft.favoriteFoods.isEmpty)
                                      Text(
                                        'None selected',
                                        style: TextStyle(
                                          color: AppColors.mutedGreen,
                                          fontSize: AppResponsive.font(
                                            context,
                                            11,
                                          ),
                                        ),
                                      )
                                    else
                                      Wrap(
                                        spacing: AppResponsive.value(
                                          context,
                                          6,
                                        ),
                                        runSpacing: AppResponsive.value(
                                          context,
                                          6,
                                        ),
                                        children: _draft.favoriteFoods
                                            .map(
                                              (item) => ProfileSelectedChip(
                                                label: item,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.edit_outlined,
                                color: AppColors.darkGreen,
                                size: AppResponsive.value(context, 16),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 12)),
                        Text(
                          'Preferences guide Discover filters and AI suggestions. They are separate from — and cannot override — your allergy restriction.',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 16)),

                  // Save & Cancel actions
                  Material(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(100),
                    child: InkWell(
                      onTap: state.isSaving
                          ? null
                          : () => context.read<ProfileBloc>().add(
                              ProfileGoalsAndPreferencesSaved(_draft),
                            ),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: AppResponsive.value(context, 52),
                        padding: EdgeInsets.only(
                          left: AppResponsive.value(context, 20),
                          right: AppResponsive.value(context, 8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.isSaving ? 'Saving...' : 'Save changes',
                              style: TextStyle(
                                color: AppColors.lime,
                                fontSize: AppResponsive.font(context, 14),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Container(
                              width: AppResponsive.value(context, 36),
                              height: AppResponsive.value(context, 36),
                              decoration: const BoxDecoration(
                                color: AppColors.lime,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: AppColors.darkGreen,
                                size: AppResponsive.value(context, 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 10)),
                  SizedBox(
                    width: double.infinity,
                    height: AppResponsive.value(context, 52),
                    child: OutlinedButton(
                      onPressed: () {
                        if (_hasUnsavedEdits) {
                          setState(() {
                            _draft = state.profile;
                            _hasUnsavedEdits = false;
                          });
                        } else {
                          context.pop();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.cream,
                        foregroundColor: AppColors.green,
                        side: const BorderSide(color: AppColors.borderGreen),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: AppResponsive.font(context, 14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 10)),
                  Center(
                    child: Text(
                      _hasUnsavedEdits
                          ? 'Unsaved edits · Tap Save changes to apply'
                          : 'Current saved settings · Save only after editing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.mutedGreen,
                        fontSize: AppResponsive.font(context, 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            foregrounds: const [ProfileBottomNav()],
          );
        },
      ),
    );
  }

  Future<void> _pickGoal() async {
    final chosen = await _showSingleChoiceSheet(
      title: 'Choose your goal',
      options: _goalOptions,
      selected: _draft.goal,
    );
    if (chosen != null) {
      _updateDraft(_draft.copyWith(goal: chosen));
    }
  }

  Future<void> _pickDietaryPattern() async {
    final chosen = await _showSingleChoiceSheet(
      title: 'Dietary pattern',
      options: _dietaryOptions,
      selected: _draft.dietaryPattern,
    );
    if (chosen != null) {
      _updateDraft(_draft.copyWith(dietaryPattern: chosen));
    }
  }

  Future<String?> _showSingleChoiceSheet({
    required String title,
    required List<String> options,
    required String selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppResponsive.value(sheetContext, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(sheetContext, 17),
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: AppResponsive.value(sheetContext, 12)),
              ...options.map((option) {
                final isSelected = option == selected;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w500,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.green)
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(option),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editAllergies() async {
    final selected = {..._draft.allergies};
    var noAllergies = _draft.noAllergies;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppResponsive.value(ctx, 20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit allergies',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(ctx, 17),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppResponsive.value(ctx, 12)),
                Wrap(
                  spacing: AppResponsive.value(ctx, 8),
                  runSpacing: AppResponsive.value(ctx, 8),
                  children: [
                    ..._allergenOptions.map((item) {
                      final active = !noAllergies && selected.contains(item);
                      return FilterChip(
                        label: Text(item),
                        selected: active,
                        selectedColor: AppColors.green,
                        checkmarkColor: AppColors.lime,
                        labelStyle: TextStyle(
                          color: active ? Colors.white : AppColors.darkGreen,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) {
                          setSheetState(() {
                            noAllergies = false;
                            if (!selected.add(item)) {
                              selected.remove(item);
                            }
                          });
                        },
                      );
                    }),
                    FilterChip(
                      label: const Text('None'),
                      selected: noAllergies,
                      selectedColor: AppColors.green,
                      checkmarkColor: AppColors.lime,
                      labelStyle: TextStyle(
                        color: noAllergies ? Colors.white : AppColors.darkGreen,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) {
                        setSheetState(() {
                          noAllergies = true;
                          selected.clear();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.value(ctx, 16)),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      _updateDraft(
                        _draft.copyWith(
                          allergies: selected,
                          noAllergies: noAllergies,
                        ),
                      );
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editMultiChipList({
    required String title,
    required List<String> options,
    required Set<String> current,
    required ValueChanged<Set<String>> onApply,
  }) async {
    final selected = {...current};

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppResponsive.value(ctx, 20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(ctx, 17),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppResponsive.value(ctx, 12)),
                Wrap(
                  spacing: AppResponsive.value(ctx, 8),
                  runSpacing: AppResponsive.value(ctx, 8),
                  children: options.map((item) {
                    final active = selected.contains(item);
                    return FilterChip(
                      label: Text(item),
                      selected: active,
                      selectedColor: AppColors.green,
                      checkmarkColor: AppColors.lime,
                      labelStyle: TextStyle(
                        color: active ? Colors.white : AppColors.darkGreen,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) {
                        setSheetState(() {
                          if (!selected.add(item)) {
                            selected.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: AppResponsive.value(ctx, 16)),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      onApply(selected);
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editTarget({
    required String label,
    required String unit,
    required int initialValue,
    required ValueChanged<int> onSaved,
  }) async {
    final controller = TextEditingController(text: initialValue.toString());
    final parsed = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: Text(
          'Edit $label ($unit)',
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(suffixText: unit),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              if (value == null) return;
              Navigator.of(dialogContext).pop(value);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (parsed != null) {
      onSaved(parsed);
    }
  }
}
