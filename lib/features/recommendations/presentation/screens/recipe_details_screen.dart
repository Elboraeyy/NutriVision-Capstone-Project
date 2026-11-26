import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_toast.dart';

const Color _darkGreen = Color(0xFF285342);
const Color _textGreen = Color(0xFF244638);
const Color _backgroundColor = Color(0xFFF8F6EE);
const Color _lightGreen = Color(0xFFE4EAD8);

/// Recipe details screen presenting ingredients, cooking steps, and macros.
class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _RecipeHeader(),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _RecipeImage(),
                          const SizedBox(height: 14),
                          const Text(
                            'Lemon salmon & couscous',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _textGreen,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _InfoChip(text: '25 min total'),
                              _InfoChip(text: 'Easy'),
                              _InfoChip(text: '30 g protein / serving'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Bright lemon, flaky salmon and a fluffy couscous base. '
                            'Simple ingredients, a satisfying bowl.',
                            style: TextStyle(
                              fontSize: 10,
                              height: 1.5,
                              color: Color(0xFF788274),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const _SectionTitle(title: 'What you’ll need'),
                          const SizedBox(height: 7),
                          const _IngredientRow(
                            name: 'Salmon fillets',
                            amount: '240 g · 2 × 120 g',
                          ),
                          const _IngredientRow(
                            name: 'Dry couscous',
                            amount: '100 g',
                          ),
                          const _IngredientRow(
                            name: 'Broccoli florets',
                            amount: '160 g',
                          ),
                          const _IngredientRow(
                            name: 'Cherry tomatoes',
                            amount: '100 g',
                          ),
                          const _IngredientRow(
                            name: 'Lemon',
                            amount: '1 · zest & juice',
                          ),
                          const _IngredientRow(
                            name: 'Olive oil',
                            amount: '2 tsp',
                          ),
                          const _IngredientRow(
                            name: 'Salt & black pepper',
                            amount: '¼ tsp each',
                          ),
                          const _IngredientRow(
                            name: 'Boiling water',
                            amount: '120 ml',
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _SectionTitle(
                                  title: 'Let’s get cooking',
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Prep 10 · Cook 15 min',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: _darkGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          const _CookingStep(
                            number: '1',
                            title: 'Prep the oven & vegetables',
                            description:
                                'Heat the oven to 200°C / 180°C fan. '
                                'Pat the salmon dry. Cut the broccoli into '
                                'small florets and halve the tomatoes. '
                                'Zest and juice the lemon.',
                          ),
                          const _CookingStep(
                            number: '2',
                            title: 'Season & roast',
                            description:
                                'Place salmon, broccoli and tomatoes on a '
                                'lined tray. Toss with 2 tsp olive oil, half '
                                'the lemon juice, all the zest, ¼ tsp salt '
                                'and ¼ tsp pepper. Roast for 12–15 min, '
                                'until salmon reaches 63°C in the thickest '
                                'part and vegetables are tender.',
                          ),
                          const _CookingStep(
                            number: '3',
                            title: 'Fluff the couscous',
                            description:
                                'While the tray roasts, put 100 g couscous '
                                'in a heatproof bowl. Pour over 120 ml '
                                'boiling water. Cover for 5 min, or follow '
                                'pack directions, then fluff with a fork. '
                                'Stir in the remaining lemon juice.',
                          ),
                          const _CookingStep(
                            number: '4',
                            title: 'Plate & enjoy',
                            description:
                                'Divide couscous and vegetables equally '
                                'between 2 bowls. Add one 120 g salmon '
                                'fillet to each. Serve warm. Refrigerate '
                                'leftovers within 2 hours and eat within '
                                '2 days.',
                          ),
                          const SizedBox(height: 10),
                          const _NutritionCard(),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 38,
                            child: OutlinedButton.icon(
                              onPressed: () => AppToast.show(
                                context,
                                message: 'Meal plan feature coming soon!',
                                type: AppToastType.info,
                              ),
                              icon: const Icon(
                                Icons.calendar_month_outlined,
                                size: 15,
                              ),
                              label: const Text(
                                'Add to Meal Plan',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _darkGreen,
                                side: const BorderSide(
                                  color: Color(0xFFC7D2B6),
                                ),
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Review serving, date and meal before confirming. '
                            'Saving or planning doesn’t log consumption.',
                            style: TextStyle(
                              fontSize: 9,
                              height: 1.4,
                              color: Color(0xFF788274),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _BottomNavigation(),
          ],
        ),
      ),
    );
  }
}

class _RecipeHeader extends StatelessWidget {
  const _RecipeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 17),
      decoration: const BoxDecoration(
        color: _darkGreen,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.maybePop(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios_new, size: 11, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Back',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 13),
          const Text(
            'Recipe details',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'A fresh favorite, step by step.',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        'https://images.unsplash.com/photo-1467003909585-2f8a72700288'
        '?auto=format&fit=crop&w=900&q=85',
        height: 168,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Container(
            height: 168,
            width: double.infinity,
            color: const Color(0xFFE5E8D9),
            child: const Icon(Icons.restaurant, size: 55, color: _darkGreen),
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC7D2B6), width: 0.7),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 8.5,
          color: _darkGreen,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: _textGreen,
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.name, required this.amount});

  final String name;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E4D9), width: 0.7),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 10, color: _textGreen),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            amount,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: _darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _CookingStep extends StatelessWidget {
  const _CookingStep({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 21,
            height: 21,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _lightGreen,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _textGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 9,
                    height: 1.4,
                    color: Color(0xFF788274),
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

class _NutritionCard extends StatelessWidget {
  const _NutritionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF0E1),
        borderRadius: BorderRadius.circular(19),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimated nutrition',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: _textGreen,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Per serving · Original recipe, no substitutions',
            style: TextStyle(fontSize: 9, color: Color(0xFF788274)),
          ),
          SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _NutritionItem(
                  value: '420',
                  label: 'kcal',
                  color: Color(0xFFDDE7D2),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: _NutritionItem(
                  value: '30 g',
                  label: 'Protein',
                  color: Color(0xFFDDE7D2),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: _NutritionItem(
                  value: '48 g',
                  label: 'Carbs',
                  color: Color(0xFFF1E5BE),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: _NutritionItem(
                  value: '12 g',
                  label: 'Fat',
                  color: Color(0xFFF4D9CB),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Estimates vary with brands, portions and cooking. '
            'Not medical advice.',
            style: TextStyle(
              fontSize: 8.5,
              height: 1.5,
              color: Color(0xFF788274),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  const _NutritionItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 8, color: _darkGreen)),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    void onTab(String label) {
      final router = GoRouter.maybeOf(context);
      switch (label) {
        case 'Home':
          if (router != null) {
            router.goNamed('home');
          } else {
            Navigator.maybePop(context);
          }
        case 'Profile':
          router?.pushNamed('profile');
        case 'Meal Plan':
        case 'Progress':
          AppToast.show(
            context,
            message: '$label will be connected soon.',
            type: AppToastType.info,
          );
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(5, 8, 5, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () => onTab('Home'),
          ),
          _NavItem(
            icon: Icons.calendar_view_week_outlined,
            label: 'Meal Plan',
            onTap: () => onTab('Meal Plan'),
          ),
          const _NavItem(
            icon: Icons.explore_outlined,
            label: 'Discover',
            selected: true,
          ),
          _NavItem(
            icon: Icons.monitor_heart_outlined,
            label: 'Progress',
            onTap: () => onTab('Progress'),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () => onTab('Profile'),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: selected
                ? const EdgeInsets.symmetric(horizontal: 11, vertical: 5)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: selected ? _darkGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              size: 19,
              color: selected ? Colors.white : _darkGreen,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? _darkGreen : _textGreen,
            ),
          ),
        ],
      ),
    );
  }
}
