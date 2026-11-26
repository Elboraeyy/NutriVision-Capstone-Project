import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../domain/entities/goals_dietary_preferences.dart';
import '../bloc/goals_dietary_bloc.dart';

/// Green rounded header with a back link to Profile & Settings.
class GoalsDietaryHeader extends StatelessWidget {
  const GoalsDietaryHeader({super.key, required this.onBack});

  static const double baseHeight = 160;
  static const double overlapDepth = 36;

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      height: topInset + AppResponsive.value(context, baseHeight),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 16),
        topInset + AppResponsive.value(context, 6),
        AppResponsive.value(context, 22),
        AppResponsive.value(context, 16),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 38)),
          bottomRight: Radius.circular(AppResponsive.value(context, 38)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 6),
                  vertical: AppResponsive.value(context, 6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: AppResponsive.value(context, 20),
                    ),
                    SizedBox(width: AppResponsive.value(context, 6)),
                    Text(
                      'Profile & Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppResponsive.font(context, 13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Padding(
            padding: EdgeInsets.only(left: AppResponsive.value(context, 6)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Goals & dietary\npreferences.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppResponsive.font(context, 25),
                    fontWeight: FontWeight.w800,
                    height: 1.06,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 6)),
                Text(
                  'Shape your targets and food choices.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.softGreen,
                    fontSize: AppResponsive.font(context, 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared card surface matching the NutriVision light-green rounded cards.
class GoalsSectionCard extends StatelessWidget {
  const GoalsSectionCard({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 18)),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.softGreen.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        border: Border.all(
          color: AppColors.borderGreen.withValues(alpha: 0.32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Dark green rounded chip with a lime checkmark matching the Figma design.
class PreferencesSelectionChip extends StatelessWidget {
  const PreferencesSelectionChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 13),
        vertical: AppResponsive.value(context, 8),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_rounded,
            color: AppColors.lime,
            size: AppResponsive.value(context, 14),
          ),
          SizedBox(width: AppResponsive.value(context, 5)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.font(context, 12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card displaying the user's primary nutrition goal with an edit button.
class YourGoalCard extends StatelessWidget {
  const YourGoalCard({super.key, required this.goal, required this.onEdit});

  final String goal;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return GoalsSectionCard(
      backgroundColor: AppColors.softGreen,
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
            key: const ValueKey('edit_goal_button'),
            onTap: onEdit,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppResponsive.value(context, 4),
              ),
              child: Row(
                children: [
                  Container(
                    width: AppResponsive.value(context, 38),
                    height: AppResponsive.value(context, 38),
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.track_changes_rounded,
                      color: Colors.white,
                      size: AppResponsive.value(context, 20),
                    ),
                  ),
                  SizedBox(width: AppResponsive.value(context, 12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal,
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 14),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 2)),
                        Text(
                          'Your primary nutrition goal',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.darkGreen,
                    size: AppResponsive.value(context, 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card displaying selected allergies, safety disclaimer, and Edit allergies button.
class AllergiesCard extends StatelessWidget {
  const AllergiesCard({
    super.key,
    required this.allergies,
    required this.onEditAllergies,
  });

  final List<String> allergies;
  final VoidCallback onEditAllergies;

  @override
  Widget build(BuildContext context) {
    return GoalsSectionCard(
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
          SizedBox(height: AppResponsive.value(context, 10)),
          if (allergies.isEmpty)
            Text(
              'No allergies selected',
              style: TextStyle(
                color: AppColors.mutedGreen,
                fontSize: AppResponsive.font(context, 12),
              ),
            )
          else
            Wrap(
              spacing: AppResponsive.value(context, 8),
              runSpacing: AppResponsive.value(context, 8),
              children: allergies
                  .map((item) => PreferencesSelectionChip(label: item))
                  .toList(),
            ),
          SizedBox(height: AppResponsive.value(context, 12)),
          Text(
            'Always check ingredient lists and food labels for cross-contact risk. AI suggestions may miss trace ingredients.',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.35,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          SizedBox(
            width: double.infinity,
            height: AppResponsive.value(context, 46),
            child: OutlinedButton(
              key: const ValueKey('edit_allergies_button'),
              onPressed: onEditAllergies,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.cream,
                foregroundColor: AppColors.darkGreen,
                side: const BorderSide(color: AppColors.borderGreen),
                shape: const StadiumBorder(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Edit allergies',
                    style: TextStyle(
                      fontSize: AppResponsive.font(context, 13),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: AppResponsive.value(context, 4)),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: AppResponsive.value(context, 18),
                    color: AppColors.darkGreen,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card displaying the five editable daily nutrition and hydration targets.
class DailyTargetsCard extends StatelessWidget {
  const DailyTargetsCard({
    super.key,
    required this.targets,
    required this.onEditTarget,
  });

  final DailyTargets targets;
  final ValueChanged<DailyTargetField> onEditTarget;

  @override
  Widget build(BuildContext context) {
    return GoalsSectionCard(
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
          SizedBox(height: AppResponsive.value(context, 8)),
          Text(
            'These targets shape future meal plans and AI recommendations. Editing and saving here does not alter already-logged entries or saved plans (those will be flagged for review).',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.35,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          _DailyTargetRow(
            fieldKey: const ValueKey('target_calories_button'),
            label: 'Calories',
            value: targets.calories,
            unit: 'kcal',
            fillColor: AppColors.cream,
            onTap: () => onEditTarget(DailyTargetField.calories),
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          _DailyTargetRow(
            fieldKey: const ValueKey('target_protein_button'),
            label: 'Protein',
            value: targets.protein,
            unit: 'g',
            fillColor: AppColors.cream,
            onTap: () => onEditTarget(DailyTargetField.protein),
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          _DailyTargetRow(
            fieldKey: const ValueKey('target_carbs_button'),
            label: 'Carbohydrates',
            value: targets.carbohydrates,
            unit: 'g',
            fillColor: AppColors.yellow,
            onTap: () => onEditTarget(DailyTargetField.carbohydrates),
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          _DailyTargetRow(
            fieldKey: const ValueKey('target_fat_button'),
            label: 'Fat',
            value: targets.fat,
            unit: 'g',
            fillColor: AppColors.peach,
            onTap: () => onEditTarget(DailyTargetField.fat),
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          _DailyTargetRow(
            fieldKey: const ValueKey('target_water_button'),
            label: 'Water',
            value: targets.water,
            unit: 'ml',
            fillColor: AppColors.cream,
            onTap: () => onEditTarget(DailyTargetField.water),
          ),
        ],
      ),
    );
  }
}

class _DailyTargetRow extends StatelessWidget {
  const _DailyTargetRow({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.unit,
    required this.fillColor,
    required this.onTap,
  });

  final Key fieldKey;
  final String label;
  final int value;
  final String unit;
  final Color fillColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'Edit $label target',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: fieldKey,
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: Ink(
                width: AppResponsive.value(context, 148),
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 14),
                  vertical: AppResponsive.value(context, 10),
                ),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.borderGreen.withValues(alpha: 0.7),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatTargetNumber(value),
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: AppResponsive.font(context, 13),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      unit,
                      style: TextStyle(
                        color: AppColors.mutedGreen,
                        fontSize: AppResponsive.font(context, 12),
                      ),
                    ),
                    SizedBox(width: AppResponsive.value(context, 8)),
                    Icon(
                      Icons.edit_outlined,
                      size: AppResponsive.value(context, 15),
                      color: AppColors.darkGreen,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatTargetNumber(int value) {
  final str = value.toString();
  if (str.length <= 3) return str;
  final buffer = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    final reverseIndex = str.length - i;
    buffer.write(str[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

/// Card for selecting the dietary pattern from onboarding options.
class DietaryPatternCard extends StatelessWidget {
  const DietaryPatternCard({
    super.key,
    required this.selectedPattern,
    required this.onPatternChanged,
  });

  final String selectedPattern;
  final ValueChanged<String> onPatternChanged;

  @override
  Widget build(BuildContext context) {
    return GoalsSectionCard(
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
          SizedBox(height: AppResponsive.value(context, 12)),
          Semantics(
            button: true,
            label: 'Dietary pattern',
            child: PopupMenuButton<String>(
              key: const ValueKey('dietary_pattern_dropdown'),
              onSelected: onPatternChanged,
              color: AppColors.cream,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              itemBuilder: (context) => GoalsDietaryPreferences
                  .availableDietaryPatterns
                  .map(
                    (pattern) => PopupMenuItem<String>(
                      value: pattern,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              pattern,
                              style: TextStyle(
                                color: AppColors.darkGreen,
                                fontSize: AppResponsive.font(context, 13),
                                fontWeight: pattern == selectedPattern
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (pattern == selectedPattern)
                            Icon(
                              Icons.check_rounded,
                              color: AppColors.green,
                              size: AppResponsive.value(context, 16),
                            ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppResponsive.value(context, 4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedPattern,
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: AppResponsive.font(context, 14),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: AppResponsive.value(context, 2)),
                          Text(
                            'Saved from onboarding · Tap to change',
                            style: TextStyle(
                              color: AppColors.mutedGreen,
                              fontSize: AppResponsive.font(context, 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.darkGreen,
                      size: AppResponsive.value(context, 22),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card displaying excluded ingredients and liked foods with edit triggers.
class FoodPreferencesCard extends StatelessWidget {
  const FoodPreferencesCard({
    super.key,
    required this.excludedIngredients,
    required this.likedFoods,
    required this.onEditExcluded,
    required this.onEditLiked,
  });

  final List<String> excludedIngredients;
  final List<String> likedFoods;
  final VoidCallback onEditExcluded;
  final VoidCallback onEditLiked;

  @override
  Widget build(BuildContext context) {
    return GoalsSectionCard(
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Excluded ingredients',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                key: const ValueKey('edit_excluded_button'),
                onPressed: onEditExcluded,
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.darkGreen,
                  size: AppResponsive.value(context, 18),
                ),
                visualDensity: VisualDensity.compact,
                tooltip: 'Edit excluded ingredients',
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          if (excludedIngredients.isEmpty)
            Text(
              'No excluded ingredients',
              style: TextStyle(
                color: AppColors.mutedGreen,
                fontSize: AppResponsive.font(context, 12),
              ),
            )
          else
            Wrap(
              spacing: AppResponsive.value(context, 8),
              runSpacing: AppResponsive.value(context, 8),
              children: excludedIngredients
                  .map((item) => PreferencesSelectionChip(label: item))
                  .toList(),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppResponsive.value(context, 14),
            ),
            child: Divider(
              height: 1,
              color: AppColors.borderGreen.withValues(alpha: 0.45),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Foods you like',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                key: const ValueKey('edit_liked_foods_button'),
                onPressed: onEditLiked,
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.darkGreen,
                  size: AppResponsive.value(context, 18),
                ),
                visualDensity: VisualDensity.compact,
                tooltip: 'Edit foods you like',
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          if (likedFoods.isEmpty)
            Text(
              'No liked foods selected',
              style: TextStyle(
                color: AppColors.mutedGreen,
                fontSize: AppResponsive.font(context, 12),
              ),
            )
          else
            Wrap(
              spacing: AppResponsive.value(context, 8),
              runSpacing: AppResponsive.value(context, 8),
              children: likedFoods
                  .map((item) => PreferencesSelectionChip(label: item))
                  .toList(),
            ),
          SizedBox(height: AppResponsive.value(context, 14)),
          Text(
            'Preferences guide Discover filters and AI suggestions. They are separate from — and cannot override — your allergy restrictions.',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal dialog for selecting the primary nutrition goal.
Future<String?> showGoalSelectionDialog(
  BuildContext context, {
  required String currentGoal,
}) {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Choose your primary goal',
        style: TextStyle(
          color: AppColors.darkGreen,
          fontSize: AppResponsive.font(dialogContext, 16),
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: GoalsDietaryPreferences.availableGoals.map((goal) {
          final isSelected = goal.toLowerCase() == currentGoal.toLowerCase();
          return ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppResponsive.value(dialogContext, 8),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            leading: Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: AppColors.green,
            ),
            title: Text(
              goal,
              style: TextStyle(
                color: AppColors.darkGreen,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            onTap: () => Navigator.of(dialogContext).pop(goal),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.mutedGreen),
          ),
        ),
      ],
    ),
  );
}

/// Modal dialog for editing a single numeric daily target with validation.
Future<int?> showDailyTargetEditDialog(
  BuildContext context, {
  required String label,
  required String unit,
  required int initialValue,
}) {
  return showDialog<int>(
    context: context,
    builder: (dialogContext) => _DailyTargetEditDialog(
      label: label,
      unit: unit,
      initialValue: initialValue,
    ),
  );
}

class _DailyTargetEditDialog extends StatefulWidget {
  const _DailyTargetEditDialog({
    required this.label,
    required this.unit,
    required this.initialValue,
  });

  final String label;
  final String unit;
  final int initialValue;

  @override
  State<_DailyTargetEditDialog> createState() => _DailyTargetEditDialogState();
}

class _DailyTargetEditDialogState extends State<_DailyTargetEditDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _controller.text.trim();
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      setState(() => _errorText = 'Enter a valid whole number.');
      return;
    }
    if (parsed < 0) {
      setState(() => _errorText = 'Value cannot be negative.');
      return;
    }
    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Edit ${widget.label} target',
        style: TextStyle(
          color: AppColors.darkGreen,
          fontSize: AppResponsive.font(context, 16),
          fontWeight: FontWeight.w800,
        ),
      ),
      content: TextField(
        key: const ValueKey('target_numeric_input'),
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))],
        decoration: InputDecoration(
          labelText: '${widget.label} (${widget.unit})',
          suffixText: widget.unit,
          errorText: _errorText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.borderGreen),
          ),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.mutedGreen),
          ),
        ),
        FilledButton(
          key: const ValueKey('apply_target_button'),
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

/// Modal dialog for multi-selecting items (allergies, excluded ingredients, liked foods)
/// with support for adding custom entries.
Future<List<String>?> showMultiSelectChipDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  required List<String> suggestions,
  required List<String> initialSelected,
  String customHint = 'Add custom item',
  List<String> blockedItems = const [],
}) {
  return showDialog<List<String>>(
    context: context,
    builder: (dialogContext) => _MultiSelectChipDialog(
      title: title,
      subtitle: subtitle,
      suggestions: suggestions,
      initialSelected: initialSelected,
      customHint: customHint,
      blockedItems: blockedItems,
    ),
  );
}

class _MultiSelectChipDialog extends StatefulWidget {
  const _MultiSelectChipDialog({
    required this.title,
    required this.subtitle,
    required this.suggestions,
    required this.initialSelected,
    required this.customHint,
    required this.blockedItems,
  });

  final String title;
  final String subtitle;
  final List<String> suggestions;
  final List<String> initialSelected;
  final String customHint;
  final List<String> blockedItems;

  @override
  State<_MultiSelectChipDialog> createState() => _MultiSelectChipDialogState();
}

class _MultiSelectChipDialogState extends State<_MultiSelectChipDialog> {
  late final List<String> _selected;
  late final List<String> _options;
  final TextEditingController _customController = TextEditingController();
  String? _warningText;

  @override
  void initState() {
    super.initState();
    _selected = [...widget.initialSelected];
    _options = [...widget.suggestions];
    for (final item in widget.initialSelected) {
      if (!_options.any((opt) => opt.toLowerCase() == item.toLowerCase())) {
        _options.add(item);
      }
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  bool _isBlocked(String item) {
    final normalized = item.trim().toLowerCase();
    return widget.blockedItems.any((blocked) {
      final b = blocked.trim().toLowerCase();
      return normalized == b ||
          normalized.contains(b) ||
          b.contains(normalized);
    });
  }

  void _toggle(String item) {
    final existingIndex = _selected.indexWhere(
      (s) => s.toLowerCase() == item.toLowerCase(),
    );
    if (existingIndex >= 0) {
      setState(() {
        _selected.removeAt(existingIndex);
        _warningText = null;
      });
      return;
    }
    if (_isBlocked(item)) {
      setState(() {
        _warningText =
            '$item conflicts with your allergy restrictions and cannot be added.';
      });
      return;
    }
    setState(() {
      _selected.add(item);
      _warningText = null;
    });
  }

  void _addCustom() {
    final raw = _customController.text.trim();
    if (raw.isEmpty) return;
    if (_isBlocked(raw)) {
      setState(() {
        _warningText =
            '$raw conflicts with your allergy restrictions and cannot be added.';
      });
      return;
    }
    setState(() {
      if (!_options.any((opt) => opt.toLowerCase() == raw.toLowerCase())) {
        _options.add(raw);
      }
      if (!_selected.any((s) => s.toLowerCase() == raw.toLowerCase())) {
        _selected.add(raw);
      }
      _warningText = null;
      _customController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        widget.title,
        style: TextStyle(
          color: AppColors.darkGreen,
          fontSize: AppResponsive.font(context, 16),
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subtitle,
              style: TextStyle(
                color: AppColors.mutedGreen,
                fontSize: AppResponsive.font(context, 12),
              ),
            ),
            SizedBox(height: AppResponsive.value(context, 12)),
            Wrap(
              spacing: AppResponsive.value(context, 8),
              runSpacing: AppResponsive.value(context, 8),
              children: _options.map((option) {
                final isSelected = _selected.any(
                  (s) => s.toLowerCase() == option.toLowerCase(),
                );
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (_) => _toggle(option),
                  selectedColor: AppColors.green,
                  checkmarkColor: AppColors.lime,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.darkGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: AppResponsive.font(context, 12),
                  ),
                  backgroundColor: AppColors.softGreen.withValues(alpha: 0.55),
                  shape: const StadiumBorder(
                    side: BorderSide(color: AppColors.borderGreen, width: 0.7),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppResponsive.value(context, 12)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey('custom_chip_input'),
                    controller: _customController,
                    decoration: InputDecoration(
                      hintText: widget.customHint,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.borderGreen,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _addCustom(),
                  ),
                ),
                SizedBox(width: AppResponsive.value(context, 8)),
                IconButton(
                  key: const ValueKey('add_custom_chip_button'),
                  onPressed: _addCustom,
                  icon: const Icon(Icons.add_circle_rounded),
                  color: AppColors.green,
                  tooltip: 'Add',
                ),
              ],
            ),
            if (_warningText != null) ...[
              SizedBox(height: AppResponsive.value(context, 8)),
              Text(
                _warningText!,
                style: TextStyle(
                  color: AppColors.errorRed,
                  fontSize: AppResponsive.font(context, 12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.mutedGreen),
          ),
        ),
        FilledButton(
          key: const ValueKey('apply_chips_button'),
          onPressed: () => Navigator.of(context).pop(_selected),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
