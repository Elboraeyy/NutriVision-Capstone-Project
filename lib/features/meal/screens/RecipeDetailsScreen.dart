import 'package:flutter/material.dart';

const Color darkGreen = Color(0xFF285342);
const Color textGreen = Color(0xFF244638);
const Color backgroundColor = Color(0xFFF8F6EE);
const Color lightGreen = Color(0xFFE4EAD8);

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RecipeHeader(),
                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const RecipeImage(),
                          const SizedBox(height: 14),

                          const Text(
                            'Lemon salmon & couscous',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textGreen,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              InfoChip(text: '25 min total'),
                              InfoChip(text: 'Easy'),
                              InfoChip(text: '30 g protein / serving'),
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

                          const SectionTitle(
                            title: 'What you’ll need',
                          ),

                          const SizedBox(height: 7),

                          const IngredientRow(
                            name: 'Salmon fillets',
                            amount: '240 g · 2 × 120 g',
                          ),
                          const IngredientRow(
                            name: 'Dry couscous',
                            amount: '100 g',
                          ),
                          const IngredientRow(
                            name: 'Broccoli florets',
                            amount: '160 g',
                          ),
                          const IngredientRow(
                            name: 'Cherry tomatoes',
                            amount: '100 g',
                          ),
                          const IngredientRow(
                            name: 'Lemon',
                            amount: '1 · zest & juice',
                          ),
                          const IngredientRow(
                            name: 'Olive oil',
                            amount: '2 tsp',
                          ),
                          const IngredientRow(
                            name: 'Salt & black pepper',
                            amount: '¼ tsp each',
                          ),
                          const IngredientRow(
                            name: 'Boiling water',
                            amount: '120 ml',
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: const [
                              SectionTitle(title: 'Let’s get cooking'),
                              Text(
                                'Prep 10 · Cook 15 min',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 9),

                          const CookingStep(
                            number: '1',
                            title: 'Prep the oven & vegetables',
                            description:
                            'Heat the oven to 200°C / 180°C fan. '
                                'Pat the salmon dry. Cut the broccoli into '
                                'small florets and halve the tomatoes. '
                                'Zest and juice the lemon.',
                          ),

                          const CookingStep(
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

                          const CookingStep(
                            number: '3',
                            title: 'Fluff the couscous',
                            description:
                            'While the tray roasts, put 100 g couscous '
                                'in a heatproof bowl. Pour over 120 ml '
                                'boiling water. Cover for 5 min, or follow '
                                'pack directions, then fluff with a fork. '
                                'Stir in the remaining lemon juice.',
                          ),

                          const CookingStep(
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

                          const NutritionCard(),

                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            height: 38,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Meal plan feature coming soon!',
                                    ),
                                  ),
                                );
                              },
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
                                foregroundColor: darkGreen,
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

            const BottomNavigation(),
          ],
        ),
      ),
    );
  }
}

// Header

class RecipeHeader extends StatelessWidget {
  const RecipeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 17),
      decoration: const BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.arrow_back_ios_new,
                size: 11,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
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
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

// Recipe image

class RecipeImage extends StatelessWidget {
  const RecipeImage({super.key});

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
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 168,
            width: double.infinity,
            color: const Color(0xFFE5E8D9),
            child: const Icon(
              Icons.restaurant,
              size: 55,
              color: darkGreen,
            ),
          );
        },
      ),
    );
  }
}

// Small information chips

class InfoChip extends StatelessWidget {
  final String text;

  const InfoChip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFC7D2B6),
          width: 0.7,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 8.5,
          color: darkGreen,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Section heading

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: textGreen,
      ),
    );
  }
}

// Ingredient row

class IngredientRow extends StatelessWidget {
  final String name;
  final String amount;

  const IngredientRow({
    super.key,
    required this.name,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E4D9),
            width: 0.7,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 10,
                color: textGreen,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            amount,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// Cooking instructions

class CookingStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const CookingStep({
    super.key,
    required this.number,
    required this.title,
    required this.description,
  });

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
              color: lightGreen,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: darkGreen,
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
                    color: textGreen,
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

// Nutrition information

class NutritionCard extends StatelessWidget {
  const NutritionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF0E1),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimated nutrition',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textGreen,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Per serving · Original recipe, no substitutions',
            style: TextStyle(
              fontSize: 9,
              color: Color(0xFF788274),
            ),
          ),

          const SizedBox(height: 11),

          const Row(
            children: [
              Expanded(
                child: NutritionItem(
                  value: '420',
                  label: 'kcal',
                  color: Color(0xFFDDE7D2),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: NutritionItem(
                  value: '30 g',
                  label: 'Protein',
                  color: Color(0xFFDDE7D2),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: NutritionItem(
                  value: '48 g',
                  label: 'Carbs',
                  color: Color(0xFFF1E5BE),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: NutritionItem(
                  value: '12 g',
                  label: 'Fat',
                  color: Color(0xFFF4D9CB),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
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

class NutritionItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const NutritionItem({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 9,
        horizontal: 5,
      ),
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
                color: darkGreen,
              ),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom navigation bar

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 8, 5, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavItem(
            icon: Icons.home_outlined,
            label: 'Home',
          ),
          NavItem(
            icon: Icons.calendar_view_week_outlined,
            label: 'Meal Plan',
          ),
          NavItem(
            icon: Icons.explore_outlined,
            label: 'Discover',
            selected: true,
          ),
          NavItem(
            icon: Icons.monitor_heart_outlined,
            label: 'Progress',
          ),
          NavItem(
            icon: Icons.person_outline,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: selected
              ? const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 5,
          )
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: selected ? darkGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            icon,
            size: 19,
            color: selected ? Colors.white : darkGreen,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight:
            selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? darkGreen : textGreen,
          ),
        ),
      ],
    );
  }
}
