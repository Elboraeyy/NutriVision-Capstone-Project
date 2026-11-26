import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../domain/entities/recipe.dart';

/// Discover screen curved forest green header.
class DiscoverHeader extends StatelessWidget {
  const DiscoverHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onSavedTap,
    this.savedCount = 0,
    this.showBack = false,
    this.onBackTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onSavedTap;
  final int savedCount;
  final bool showBack;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 42)),
          bottomRight: Radius.circular(AppResponsive.value(context, 42)),
        ),
      ),
      padding: EdgeInsets.only(
        top:
            MediaQuery.paddingOf(context).top +
            AppResponsive.value(context, 10),
        bottom: AppResponsive.value(context, 24),
        left: AppResponsive.value(context, 20),
        right: AppResponsive.value(context, 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBack)
                InkWell(
                  onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
                  borderRadius: BorderRadius.circular(100),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: AppResponsive.value(context, 20),
                      ),
                      SizedBox(width: AppResponsive.value(context, 2)),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppResponsive.font(context, 12),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: Text(
                    'NutriVision',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppResponsive.font(context, 13),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (onSavedTap != null)
                Flexible(
                  child: InkWell(
                    onTap: onSavedTap,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.value(context, 8),
                        vertical: AppResponsive.value(context, 4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_outline_rounded,
                            color: Colors.white,
                            size: AppResponsive.value(context, 15),
                          ),
                          SizedBox(width: AppResponsive.value(context, 4)),
                          Flexible(
                            child: Text(
                              savedCount > 0
                                  ? 'Saved ($savedCount)'
                                  : 'Saved recipes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppResponsive.font(context, 11),
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppResponsive.font(context, 28),
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 6)),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.softGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w400,
                    height: 1.45,
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

/// Pill-shaped search bar for discovering recipes.
class DiscoverSearchBar extends StatelessWidget {
  const DiscoverSearchBar({
    super.key,
    this.hintText = 'Search recipes or ingredients',
    this.controller,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.onFilterTap,
  });

  final String hintText;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.value(context, 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xFFDCE1D2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppColors.mutedGreen,
            size: AppResponsive.value(context, 18),
          ),
          SizedBox(width: AppResponsive.value(context, 10)),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: onChanged,
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: AppResponsive.font(context, 13),
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 13),
                  fontWeight: FontWeight.w400,
                ),
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
          if (onFilterTap != null)
            InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(100),
              child: Padding(
                padding: EdgeInsets.all(AppResponsive.value(context, 4)),
                child: Icon(
                  Icons.tune_rounded,
                  color: AppColors.green,
                  size: AppResponsive.value(context, 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Small preference reassurance banner.
class PreferenceNotice extends StatelessWidget {
  const PreferenceNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.verified_user_outlined,
          color: AppColors.mutedGreen,
          size: AppResponsive.value(context, 16),
        ),
        SizedBox(width: AppResponsive.value(context, 8)),
        Expanded(
          child: Text(
            'Uses your saved food preferences & allergy settings.',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 11),
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

/// Large featured recipe card matching Figma node 206:6882.
class FeaturedRecipeCard extends StatelessWidget {
  const FeaturedRecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onSaveTap,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You might like these Meals',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: AppResponsive.font(context, 17),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 12)),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppResponsive.value(context, 10)),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF0E1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: AppResponsive.value(context, 175),
                    width: double.infinity,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFDCE1D2),
                        child: Center(
                          child: Icon(
                            Icons.restaurant_rounded,
                            size: AppResponsive.value(context, 48),
                            color: AppColors.green.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppResponsive.value(context, 6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              recipe.title,
                              style: TextStyle(
                                color: AppColors.darkGreen,
                                fontSize: AppResponsive.font(context, 19),
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: onSaveTap,
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: AppResponsive.value(context, 32),
                              height: AppResponsive.value(context, 32),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                recipe.isSaved
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_outline_rounded,
                                color: AppColors.green,
                                size: AppResponsive.value(context, 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppResponsive.value(context, 4)),
                      Text(
                        '${recipe.totalTime} · ${recipe.difficulty}',
                        style: TextStyle(
                          color: AppColors.mutedGreen,
                          fontSize: AppResponsive.font(context, 11),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppResponsive.value(context, 4)),
                      Text(
                        'Est. ${recipe.calories} kcal · ${recipe.protein} protein',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: AppResponsive.font(context, 12),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppResponsive.value(context, 2)),
                      Text(
                        recipe.tagline,
                        style: TextStyle(
                          color: AppColors.mutedGreen,
                          fontSize: AppResponsive.font(context, 11),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Horizontal recipe item matching Figma everyday recipes list (206:6894).
class EverydayRecipeCard extends StatelessWidget {
  const EverydayRecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onSaveTap,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onSaveTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppResponsive.value(context, 10)),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF0E1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: AppResponsive.value(context, 96),
                height: AppResponsive.value(context, 120),
                child: Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFDCE1D2),
                    child: Center(
                      child: Icon(
                        Icons.lunch_dining_rounded,
                        size: AppResponsive.value(context, 32),
                        color: AppColors.green.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppResponsive.value(context, 12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 16),
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: onSaveTap,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: AppResponsive.value(context, 28),
                          height: AppResponsive.value(context, 28),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            recipe.isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline_rounded,
                            color: AppColors.green,
                            size: AppResponsive.value(context, 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.value(context, 6)),
                  Text(
                    '${recipe.totalTime} · ${recipe.difficulty}',
                    style: TextStyle(
                      color: AppColors.mutedGreen,
                      fontSize: AppResponsive.font(context, 11),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 4)),
                  Text(
                    'Est. ${recipe.calories} kcal · ${recipe.protein} protein',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: AppResponsive.font(context, 12),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chat with AI floating action banner matching Figma.
class ChatWithAiBanner extends StatelessWidget {
  const ChatWithAiBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: double.infinity,
        height: AppResponsive.value(context, 54),
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.value(context, 20),
        ),
        decoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: AppColors.green.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chat with AI',
              style: TextStyle(
                color: const Color(0xFFBDE274),
                fontSize: AppResponsive.font(context, 16),
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              width: AppResponsive.value(context, 34),
              height: AppResponsive.value(context, 34),
              decoration: const BoxDecoration(
                color: Color(0xFFBDE274),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.green,
                size: AppResponsive.value(context, 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Refine recipes filter card matching Figma node 206:6769.
class RefineRecipesPanel extends StatelessWidget {
  const RefineRecipesPanel({
    super.key,
    required this.selectedIngredients,
    required this.onIngredientToggled,
    required this.maxCalories,
    required this.onCaloriesChanged,
    required this.minProtein,
    required this.onProteinChanged,
    required this.onReset,
    required this.onApply,
    required this.matchesCount,
  });

  final List<String> selectedIngredients;
  final ValueChanged<String> onIngredientToggled;
  final int maxCalories;
  final ValueChanged<int> onCaloriesChanged;
  final int minProtein;
  final ValueChanged<int> onProteinChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;
  final int matchesCount;

  static const _availablePantry = [
    'Oats',
    'Berries',
    'Salmon',
    'Chicken',
    'Quinoa',
    'Chickpeas',
    'Spinach',
    'Avocado',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 16)),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF0E1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Refine your recipes',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 17),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              InkWell(
                onTap: onReset,
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.value(context, 6),
                    vertical: AppResponsive.value(context, 2),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: AppResponsive.font(context, 12),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          Text(
            'Ingredients you have',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 13),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 8)),
          Wrap(
            spacing: AppResponsive.value(context, 8),
            runSpacing: AppResponsive.value(context, 8),
            children: _availablePantry.map((item) {
              final isSelected = selectedIngredients.contains(item);
              return FilterChip(
                label: Text(item),
                selected: isSelected,
                onSelected: (_) => onIngredientToggled(item),
                selectedColor: AppColors.green,
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 12),
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.green
                        : const Color(0xFFDCE1D2),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: AppResponsive.value(context, 6)),
          Text(
            'Example pantry selections · Edit anytime',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 11),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Calories',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'Up to $maxCalories kcal',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: AppResponsive.font(context, 12),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.green,
              inactiveTrackColor: const Color(0xFFDCE1D2),
              thumbColor: const Color(0xFFBDE274),
              trackHeight: 3,
            ),
            child: Slider(
              value: maxCalories.toDouble(),
              min: 100,
              max: 800,
              divisions: 14,
              onChanged: (v) => onCaloriesChanged(v.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '100 kcal',
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 11),
                ),
              ),
              Text(
                '800 kcal',
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 11),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Protein',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'At least $minProtein g',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: AppResponsive.font(context, 12),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.green,
              inactiveTrackColor: const Color(0xFFDCE1D2),
              thumbColor: const Color(0xFFBDE274),
              trackHeight: 3,
            ),
            child: Slider(
              value: minProtein.toDouble(),
              min: 0,
              max: 50,
              divisions: 10,
              onChanged: (v) => onProteinChanged(v.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 g',
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 11),
                ),
              ),
              Text(
                '50 g+',
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 11),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 16)),
          InkWell(
            onTap: onApply,
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: double.infinity,
              height: AppResponsive.value(context, 48),
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show $matchesCount ${matchesCount == 1 ? 'recipe' : 'recipes'}',
                    style: TextStyle(
                      color: const Color(0xFFBDE274),
                      fontSize: AppResponsive.font(context, 15),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: AppResponsive.value(context, 8)),
                  Icon(
                    Icons.search_rounded,
                    color: const Color(0xFFBDE274),
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
