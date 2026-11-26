import 'package:flutter/material.dart';

import '../../../../core/widgets/app_toast.dart';

/// Logged meal details screen displaying nutrition breakdown and ingredients.
class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  static const Color _darkGreen = Color(0xFF285140);
  static const Color _textGreen = Color(0xFF244538);
  static const Color _background = Color(0xFFF7F5ED);
  static const Color _lightGreen = Color(0xFFEBEFDF);
  static const Color _yellow = Color(0xFFF2E7B5);
  static const Color _lime = Color(0xFFB8D84E);
  static const Color _mutedText = Color(0xFF7C887B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 20, 14, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMealImage(),
                    const SizedBox(height: 18),
                    _buildMealStatus(),
                    const SizedBox(height: 10),
                    const Text(
                      'Chicken & quinoa bowl',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: _textGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '1 bowl · Logged at 12:30 PM',
                      style: TextStyle(fontSize: 13, color: _mutedText),
                    ),
                    const SizedBox(height: 20),
                    _buildNutritionCard(),
                    const SizedBox(height: 20),
                    const Text(
                      'What’s in your bowl',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Estimated portions · 1 serving',
                      style: TextStyle(fontSize: 12, color: _mutedText),
                    ),
                    const SizedBox(height: 8),
                    _buildIngredientsCard(),
                    const SizedBox(height: 20),
                    const Text(
                      'Nutrition is estimated from the listed foods and portions. '
                      'Ingredients, brands and preparation can change the values.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.45,
                        color: _mutedText,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildEditButton(context),
                    const SizedBox(height: 18),
                    _buildDeleteButton(context),
                    const SizedBox(height: 10),
                    const Text(
                      'You’ll be asked to confirm before deleting. '
                      'Undo is available immediately after deletion.',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.4,
                        color: _mutedText,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Nutrition estimates, not medical advice.',
                      style: TextStyle(fontSize: 10, color: _mutedText),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 24,
              alignment: Alignment.center,
              color: _background,
              child: Container(
                width: 120,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF193C30),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 12,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        color: _darkGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(42),
          bottomRight: Radius.circular(42),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Meal details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Wednesday, Oct 14 · Lunch at 12:30 PM',
            style: TextStyle(color: Color(0xFFE1E8D6), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildMealImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'assets/images/Chicken and quinoa bowl.png',
        width: double.infinity,
        height: 236,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: double.infinity,
          height: 236,
          color: _lightGreen,
          alignment: Alignment.center,
          child: const Icon(Icons.restaurant, size: 56, color: _darkGreen),
        ),
      ),
    );
  }

  Widget _buildMealStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E9D5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 14, color: _darkGreen),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              'Eaten · Included in daily totals',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _textGreen,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
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
                        color: _textGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'For the whole bowl',
                      style: TextStyle(color: _mutedText, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '520',
                    style: TextStyle(
                      fontSize: 30,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      color: _darkGreen,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'kcal',
                    style: TextStyle(color: _mutedText, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MacroCard(
                  title: 'Protein',
                  value: '40 g',
                  color: Color(0xFFE0E8D3),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MacroCard(
                  title: 'Carbs',
                  value: '54 g',
                  color: Color(0xFFF2E7B5),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MacroCard(
                  title: 'Fat',
                  value: '16 g',
                  color: Color(0xFFF3D8C9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: _yellow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
        children: [
          _IngredientRow(
            title: 'Grilled chicken breast',
            subtitle: 'Skinless, cooked',
            amount: '100 g',
          ),
          _IngredientRow(
            title: 'Cooked quinoa',
            subtitle: 'About ¾ cup',
            amount: '150 g',
          ),
          _IngredientRow(title: 'Avocado', subtitle: 'Sliced', amount: '40 g'),
          _IngredientRow(
            title: 'Mixed vegetables',
            subtitle: 'Tomato, greens & cucumber',
            amount: '80 g',
          ),
          _IngredientRow(
            title: 'Lemon dressing',
            subtitle: 'Lemon, honey & olive oil',
            amount: '20 g',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => AppToast.show(
          context,
          message: 'Editing logged meals will be available soon.',
          type: AppToastType.info,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkGreen,
          foregroundColor: _lime,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          children: [
            const Text(
              'Edit entry',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: _lime,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.north_east, color: _darkGreen, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Delete meal?'),
              content: const Text('Are you sure you want to delete this meal?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
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
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.delete_outline, size: 18),
        label: const Text(
          'Delete meal',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF9A4A37),
          side: const BorderSide(color: Color(0xFFD6B9A9)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: MealDetailsScreen._textGreen,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MealDetailsScreen._textGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final String amount;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFDCD2A9), width: 1),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: MealDetailsScreen._textGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: MealDetailsScreen._mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MealDetailsScreen._textGreen,
            ),
          ),
        ],
      ),
    );
  }
}
