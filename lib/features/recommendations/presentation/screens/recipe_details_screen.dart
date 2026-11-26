import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_floating_navigation_bar.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';

/// Recipe details screen presenting ingredients, cooking steps, and macros.
///
/// Fully aligned with the NutriVision design system: cream background,
/// dark green header, floating navigation bar, rounded cards, and responsive tokens.
class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key});

  static const double _headerHeight = 165;

  void _onNavSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed('home');
        }
      case 1:
        AppToast.show(
          context,
          message: 'Meal Plan will be connected soon.',
          type: AppToastType.info,
        );
      case 2:
        // Already on Discover / Recipe details
        break;
      case 3:
        AppToast.show(
          context,
          message: 'Progress will be connected soon.',
          type: AppToastType.info,
        );
      case 4:
        context.pushNamed('profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: const _RecipeHeader(headerHeight: _headerHeight),
        body: const _RecipeContent(headerHeight: _headerHeight),
        foreground: Positioned(
          left: AppResponsive.value(context, 14),
          right: AppResponsive.value(context, 14),
          bottom: AppResponsive.value(context, 8),
          child: AppFloatingNavigationBar(
            selectedIndex: 2,
            onSelected: (index) => _onNavSelected(context, index),
          ),
        ),
      ),
    );
  }
}

class _RecipeHeader extends StatelessWidget {
  const _RecipeHeader({required this.headerHeight});

  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      height: topInset + AppResponsive.value(context, headerHeight),
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 20),
        topInset + AppResponsive.value(context, 10),
        AppResponsive.value(context, 20),
        AppResponsive.value(context, 18),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.maybePop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.value(context, 4),
                      vertical: AppResponsive.value(context, 4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: AppResponsive.value(context, 15),
                        ),
                        SizedBox(width: AppResponsive.value(context, 6)),
                        Text(
                          'Back',
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 10),
                  vertical: AppResponsive.value(context, 4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.softGreen.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.explore_rounded,
                      color: AppColors.lime,
                      size: AppResponsive.value(context, 13),
                    ),
                    SizedBox(width: AppResponsive.value(context, 4)),
                    Text(
                      'DISCOVER',
                      style: TextStyle(
                        color: AppColors.lime,
                        fontSize: AppResponsive.font(context, 10),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Recipe details',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppResponsive.font(context, 26),
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'A fresh favorite, step by step.',
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: AppResponsive.font(context, 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeContent extends StatelessWidget {
  const _RecipeContent({required this.headerHeight});

  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final topPadding =
        AppOverlayScaffold.contentTop(context, headerHeight) +
        AppResponsive.value(context, 14);
    final bottomPadding = AppResponsive.value(context, 90);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 18),
        topPadding,
        AppResponsive.value(context, 18),
        bottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RecipeHeroCard(),
          SizedBox(height: AppResponsive.value(context, 14)),
          const _RecipeTitleSection(),
          SizedBox(height: AppResponsive.value(context, 14)),
          const _NutritionBreakdownCard(),
          SizedBox(height: AppResponsive.value(context, 16)),
          const _IngredientsSection(),
          SizedBox(height: AppResponsive.value(context, 16)),
          const _CookingStepsSection(),
          SizedBox(height: AppResponsive.value(context, 18)),
          const _ActionSection(),
        ],
      ),
    );
  }
}

class _RecipeHeroCard extends StatelessWidget {
  const _RecipeHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
        child: Stack(
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1467003909585-2f8a72700288'
              '?auto=format&fit=crop&w=900&q=85',
              height: AppResponsive.value(context, 200),
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return Container(
                  height: AppResponsive.value(context, 200),
                  width: double.infinity,
                  color: AppColors.softGreen,
                  child: Icon(
                    Icons.restaurant_rounded,
                    size: AppResponsive.value(context, 50),
                    color: AppColors.green,
                  ),
                );
              },
            ),
            Positioned(
              top: AppResponsive.value(context, 12),
              right: AppResponsive.value(context, 12),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.value(context, 10),
                  vertical: AppResponsive.value(context, 5),
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkGreen.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.lime,
                      size: AppResponsive.value(context, 14),
                    ),
                    SizedBox(width: AppResponsive.value(context, 4)),
                    Text(
                      '420 kcal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppResponsive.font(context, 11),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeTitleSection extends StatelessWidget {
  const _RecipeTitleSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 22)),
        border: Border.all(color: AppColors.softGreen, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lemon salmon & couscous',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 21),
              fontWeight: FontWeight.w800,
              color: AppColors.darkGreen,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          Wrap(
            spacing: AppResponsive.value(context, 8),
            runSpacing: AppResponsive.value(context, 8),
            children: const [
              _InfoChip(
                icon: Icons.schedule_rounded,
                text: '25 min total',
                backgroundColor: AppColors.softGreen,
              ),
              _InfoChip(
                icon: Icons.auto_awesome_rounded,
                text: 'Easy',
                backgroundColor: AppColors.yellow,
              ),
              _InfoChip(
                icon: Icons.fitness_center_rounded,
                text: '30 g protein / serving',
                backgroundColor: AppColors.peach,
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          Text(
            'Bright lemon, flaky salmon and a fluffy couscous base. '
            'Simple ingredients, a satisfying bowl.',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 13),
              height: 1.5,
              color: AppColors.mutedGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.backgroundColor,
  });

  final IconData icon;
  final String text;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 10),
        vertical: AppResponsive.value(context, 6),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppResponsive.value(context, 13),
            color: AppColors.darkGreen,
          ),
          SizedBox(width: AppResponsive.value(context, 4)),
          Text(
            text,
            style: TextStyle(
              fontSize: AppResponsive.font(context, 11),
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionBreakdownCard extends StatelessWidget {
  const _NutritionBreakdownCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated nutrition',
                      style: TextStyle(
                        fontSize: AppResponsive.font(context, 15),
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    SizedBox(height: AppResponsive.value(context, 4)),
                    Text(
                      'Per serving · Original recipe, no substitutions',
                      style: TextStyle(
                        fontSize: AppResponsive.font(context, 11),
                        color: AppColors.mutedGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '420',
                    style: TextStyle(
                      fontSize: AppResponsive.font(context, 28),
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 3)),
                  Text(
                    'kcal',
                    style: TextStyle(
                      fontSize: AppResponsive.font(context, 11),
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 12)),
          Row(
            children: const [
              Expanded(
                child: _MacroCard(
                  label: 'Protein',
                  value: '30 g',
                  color: AppColors.cream,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MacroCard(
                  label: 'Carbs',
                  value: '48 g',
                  color: AppColors.yellow,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MacroCard(
                  label: 'Fat',
                  value: '12 g',
                  color: AppColors.peach,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          Text(
            'Estimates vary with brands, portions and cooking. Not medical advice.',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 10),
              height: 1.4,
              color: AppColors.mutedGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppResponsive.value(context, 10),
        horizontal: AppResponsive.value(context, 8),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppResponsive.font(context, 15),
                fontWeight: FontWeight.w800,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 3)),
          Text(
            label,
            style: TextStyle(
              fontSize: AppResponsive.font(context, 10),
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientsSection extends StatelessWidget {
  const _IngredientsSection();

  static const _ingredients = [
    ('Salmon fillets', '240 g · 2 × 120 g'),
    ('Dry couscous', '100 g'),
    ('Broccoli florets', '160 g'),
    ('Cherry tomatoes', '100 g'),
    ('Lemon', '1 · zest & juice'),
    ('Olive oil', '2 tsp'),
    ('Salt & black pepper', '¼ tsp each'),
    ('Boiling water', '120 ml'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'What you’ll need',
                style: TextStyle(
                  fontSize: AppResponsive.font(context, 18),
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.value(context, 9),
                vertical: AppResponsive.value(context, 4),
              ),
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '8 ingredients',
                style: TextStyle(
                  fontSize: AppResponsive.font(context, 11),
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.value(context, 10)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, 16),
            vertical: AppResponsive.value(context, 6),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              AppResponsive.value(context, 22),
            ),
            border: Border.all(color: AppColors.softGreen, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkGreen.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: List.generate(_ingredients.length, (index) {
              final item = _ingredients[index];
              final isLast = index == _ingredients.length - 1;
              return _IngredientRow(
                name: item.$1,
                amount: item.$2,
                isLast: isLast,
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.name,
    required this.amount,
    required this.isLast,
  });

  final String name;
  final String amount;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppResponsive.value(context, 11)),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.cream, width: 1.5),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: AppResponsive.value(context, 8),
            height: AppResponsive.value(context, 8),
            decoration: const BoxDecoration(
              color: AppColors.lime,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppResponsive.value(context, 10)),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: AppResponsive.font(context, 13),
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.value(context, 8),
              vertical: AppResponsive.value(context, 3),
            ),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              amount,
              style: TextStyle(
                fontSize: AppResponsive.font(context, 11),
                fontWeight: FontWeight.w700,
                color: AppColors.darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CookingStepsSection extends StatelessWidget {
  const _CookingStepsSection();

  static const _steps = [
    (
      '1',
      'Prep the oven & vegetables',
      'Heat the oven to 200°C / 180°C fan. Pat the salmon dry. '
          'Cut the broccoli into small florets and halve the tomatoes. '
          'Zest and juice the lemon.',
    ),
    (
      '2',
      'Season & roast',
      'Place salmon, broccoli and tomatoes on a lined tray. '
          'Toss with 2 tsp olive oil, half the lemon juice, all the zest, '
          '¼ tsp salt and ¼ tsp pepper. Roast for 12–15 min, until salmon '
          'reaches 63°C in the thickest part and vegetables are tender.',
    ),
    (
      '3',
      'Fluff the couscous',
      'While the tray roasts, put 100 g couscous in a heatproof bowl. '
          'Pour over 120 ml boiling water. Cover for 5 min, or follow pack '
          'directions, then fluff with a fork. Stir in the remaining lemon juice.',
    ),
    (
      '4',
      'Plate & enjoy',
      'Divide couscous and vegetables equally between 2 bowls. '
          'Add one 120 g salmon fillet to each. Serve warm. '
          'Refrigerate leftovers within 2 hours and eat within 2 days.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Let’s get cooking',
                style: TextStyle(
                  fontSize: AppResponsive.font(context, 18),
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.value(context, 9),
                vertical: AppResponsive.value(context, 4),
              ),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: AppResponsive.value(context, 13),
                    color: AppColors.darkGreen,
                  ),
                  SizedBox(width: AppResponsive.value(context, 4)),
                  Text(
                    'Prep 10 · Cook 15 min',
                    style: TextStyle(
                      fontSize: AppResponsive.font(context, 11),
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.value(context, 12)),
        ..._steps.map(
          (step) => Padding(
            padding: EdgeInsets.only(bottom: AppResponsive.value(context, 10)),
            child: _CookingStepCard(
              number: step.$1,
              title: step.$2,
              description: step.$3,
            ),
          ),
        ),
      ],
    );
  }
}

class _CookingStepCard extends StatelessWidget {
  const _CookingStepCard({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppResponsive.value(context, 14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 18)),
        border: Border.all(color: AppColors.softGreen, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppResponsive.value(context, 28),
            height: AppResponsive.value(context, 28),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                fontSize: AppResponsive.font(context, 12),
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: AppResponsive.value(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 14),
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 4)),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 12),
                    height: 1.45,
                    color: AppColors.mutedGreen,
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

class _ActionSection extends StatelessWidget {
  const _ActionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppResponsive.value(context, 48),
          child: ElevatedButton.icon(
            onPressed: () => AppToast.show(
              context,
              message: 'Meal plan feature coming soon!',
              type: AppToastType.info,
            ),
            icon: Icon(
              Icons.calendar_month_rounded,
              size: AppResponsive.value(context, 18),
            ),
            label: Text(
              'Add to Meal Plan',
              style: TextStyle(
                fontSize: AppResponsive.font(context, 14),
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: const StadiumBorder(),
            ),
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 10)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, 10),
          ),
          child: Text(
            'Review serving, date and meal before confirming. '
            'Saving or planning doesn’t log consumption.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppResponsive.font(context, 11),
              height: 1.4,
              color: AppColors.mutedGreen,
            ),
          ),
        ),
      ],
    );
  }
}
