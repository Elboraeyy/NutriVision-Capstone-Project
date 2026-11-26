import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';

/// Logged meal details screen displaying nutrition breakdown and ingredients.
///
/// Refactored to align with NutriVision design language: AppColors, AppResponsive,
/// rounded card surfaces, AppOverlayScaffold, and clean typography.
class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  static const double _headerHeight = 165;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: const _MealDetailsHeader(headerHeight: _headerHeight),
        body: const _MealDetailsContent(headerHeight: _headerHeight),
      ),
    );
  }
}

class _MealDetailsHeader extends StatelessWidget {
  const _MealDetailsHeader({required this.headerHeight});

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
                      Icons.restaurant_menu_rounded,
                      color: AppColors.lime,
                      size: AppResponsive.value(context, 13),
                    ),
                    SizedBox(width: AppResponsive.value(context, 4)),
                    Text(
                      'LOGGED MEAL',
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
              'Meal details',
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
            'Wednesday, Oct 14 · Lunch at 12:30 PM',
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

class _MealDetailsContent extends StatelessWidget {
  const _MealDetailsContent({required this.headerHeight});

  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final topPadding =
        AppOverlayScaffold.contentTop(context, headerHeight) +
        AppResponsive.value(context, 14);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 18),
        topPadding,
        AppResponsive.value(context, 18),
        AppResponsive.value(context, 32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MealHeroImage(),
          SizedBox(height: AppResponsive.value(context, 14)),
          const _MealTitleSection(),
          SizedBox(height: AppResponsive.value(context, 16)),
          const _MealNutritionBreakdownCard(),
          SizedBox(height: AppResponsive.value(context, 18)),
          const _MealIngredientsSection(),
          SizedBox(height: AppResponsive.value(context, 16)),
          Text(
            'Nutrition is estimated from the listed foods and portions. '
            'Ingredients, brands and preparation can change the values.',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 11),
              height: 1.45,
              color: AppColors.mutedGreen,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 20)),
          const _MealActionButtons(),
          SizedBox(height: AppResponsive.value(context, 10)),
          Center(
            child: Text(
              'Nutrition estimates, not medical advice.',
              style: TextStyle(
                fontSize: AppResponsive.font(context, 11),
                color: AppColors.mutedGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealHeroImage extends StatelessWidget {
  const _MealHeroImage();

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
        child: Image.asset(
          'assets/images/Chicken and quinoa bowl.png',
          width: double.infinity,
          height: AppResponsive.value(context, 210),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            width: double.infinity,
            height: AppResponsive.value(context, 210),
            color: AppColors.softGreen,
            alignment: Alignment.center,
            child: Icon(
              Icons.restaurant_rounded,
              size: AppResponsive.value(context, 54),
              color: AppColors.green,
            ),
          ),
        ),
      ),
    );
  }
}

class _MealTitleSection extends StatelessWidget {
  const _MealTitleSection();

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
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.value(context, 10),
              vertical: AppResponsive.value(context, 5),
            ),
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: AppResponsive.value(context, 14),
                  color: AppColors.darkGreen,
                ),
                SizedBox(width: AppResponsive.value(context, 6)),
                Flexible(
                  child: Text(
                    'Eaten · Included in daily totals',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: AppResponsive.font(context, 11),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          Text(
            'Chicken & quinoa bowl',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 22),
              fontWeight: FontWeight.w800,
              color: AppColors.darkGreen,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            '1 bowl · Logged at 12:30 PM',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 13),
              color: AppColors.mutedGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealNutritionBreakdownCard extends StatelessWidget {
  const _MealNutritionBreakdownCard();

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
                      'For the whole bowl',
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
                    '520',
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
                child: _MealMacroPill(
                  label: 'Protein',
                  value: '40 g',
                  color: AppColors.cream,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MealMacroPill(
                  label: 'Carbs',
                  value: '54 g',
                  color: AppColors.yellow,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MealMacroPill(
                  label: 'Fat',
                  value: '16 g',
                  color: AppColors.peach,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MealMacroPill extends StatelessWidget {
  const _MealMacroPill({
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

class _MealIngredientsSection extends StatelessWidget {
  const _MealIngredientsSection();

  static const _ingredients = [
    ('Grilled chicken breast', 'Skinless, cooked', '100 g'),
    ('Cooked quinoa', 'About ¾ cup', '150 g'),
    ('Avocado', 'Sliced', '40 g'),
    ('Mixed vegetables', 'Tomato, greens & cucumber', '80 g'),
    ('Lemon dressing', 'Lemon, honey & olive oil', '20 g'),
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
                'What’s in your bowl',
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
                '1 serving',
                style: TextStyle(
                  fontSize: AppResponsive.font(context, 11),
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.value(context, 4)),
        Text(
          'Estimated portions · 1 serving',
          style: TextStyle(
            fontSize: AppResponsive.font(context, 12),
            color: AppColors.mutedGreen,
          ),
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
              return _MealIngredientRow(
                title: item.$1,
                subtitle: item.$2,
                amount: item.$3,
                isLast: isLast,
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _MealIngredientRow extends StatelessWidget {
  const _MealIngredientRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isLast,
  });

  final String title;
  final String subtitle;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 2)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppResponsive.font(context, 11),
                    color: AppColors.mutedGreen,
                  ),
                ),
              ],
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

class _MealActionButtons extends StatelessWidget {
  const _MealActionButtons();

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
              message: 'Editing logged meals will be available soon.',
              type: AppToastType.info,
            ),
            icon: Icon(
              Icons.edit_note_rounded,
              size: AppResponsive.value(context, 20),
            ),
            label: Text(
              'Edit entry',
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
        SizedBox(height: AppResponsive.value(context, 12)),
        SizedBox(
          width: double.infinity,
          height: AppResponsive.value(context, 46),
          child: OutlinedButton.icon(
            onPressed: () => _confirmDelete(context),
            icon: Icon(
              Icons.delete_outline_rounded,
              size: AppResponsive.value(context, 18),
            ),
            label: Text(
              'Delete meal',
              style: TextStyle(
                fontSize: AppResponsive.font(context, 13),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF9A4A37),
              side: const BorderSide(color: Color(0xFFD6B9A9)),
              shape: const StadiumBorder(),
            ),
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 10)),
        Text(
          'You’ll be asked to confirm before deleting. '
          'Undo is available immediately after deletion.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppResponsive.font(context, 11),
            height: 1.4,
            color: AppColors.mutedGreen,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete meal?'),
        content: const Text('Are you sure you want to delete this meal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.darkGreen),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              AppToast.show(
                context,
                message: 'Meal deletion will be connected soon.',
                type: AppToastType.info,
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
