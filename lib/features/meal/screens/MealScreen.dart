
import 'package:flutter/material.dart';

const Color darkGreen = Color(0xFF285341);
const Color textGreen = Color(0xFF244438);
const Color cream = Color(0xFFF7F4EC);
const Color lightGreen = Color(0xFFEDF0E1);
const Color borderGreen = Color(0xFFB8CBA3);

// Main screen

class MealScreen extends StatelessWidget {
  const MealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const MealHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(19, 20, 19, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MealInfo(),
                    const SizedBox(height: 20),

                    const Text(
                      'Foods & portions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textGreen,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Correct detected foods and portions before saving.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF718071),
                      ),
                    ),
                    const SizedBox(height: 10),

                    const FoodCard(
                      name: 'Grilled chicken',
                      amount: '100',
                    ),
                    const SizedBox(height: 10),

                    const FoodCard(
                      name: 'Cooked quinoa',
                      amount: '150',
                    ),
                    const SizedBox(height: 10),

                    const FoodCard(
                      name: 'Avocado',
                      amount: '40',
                      warning: true,
                    ),
                    const SizedBox(height: 10),

                    const FoodCard(
                      name: 'Mixed vegetables',
                      amount: '80',
                    ),
                    const SizedBox(height: 10),

                    const AddFoodButton(),
                    const SizedBox(height: 17),

                    const PortionWarning(),
                    const SizedBox(height: 17),

                    const NutritionCard(),
                    const SizedBox(height: 18),

                    const Text(
                      'Nutrition values are estimates, not medical advice.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718071),
                      ),
                    ),
                    const SizedBox(height: 17),

                    const ConfirmButton(),
                    const SizedBox(height: 12),

                    const Text(
                      'Confirmed food updates Diary, Home and Progress together.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718071),
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

// Header

class MealHeader extends StatelessWidget {
  const MealHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        20,
        24,
      ),
      decoration: const BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 21),
                SizedBox(width: 10),
                Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          const Text(
            'Make it your meal',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'AI results & review · Not yet in your diary',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFD5E0D9),
            ),
          ),
        ],
      ),
    );
  }
}

// Meal information

class MealInfo extends StatelessWidget {
  const MealInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 73,
              height: 73,
              margin: const EdgeInsets.only(right: 12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: lightGreen,
              ),
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.restaurant,
                    size: 32,
                    color: darkGreen,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meal name',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF718071),
                    ),
                  ),
                  SizedBox(height: 6),
                  EditableBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Chicken & quinoa bowl',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textGreen,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: darkGreen,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 17),
        Row(
          children: [
            const Expanded(
              child: EditableBox(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Dinner',
                        style: TextStyle(color: textGreen, fontSize: 14),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: darkGreen),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 9),
            const Expanded(
              child: EditableBox(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Today · 6:30 PM',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textGreen, fontSize: 13),
                      ),
                    ),
                    Icon(Icons.edit_outlined, size: 19, color: darkGreen),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Reusable outlined box

class EditableBox extends StatelessWidget {
  final Widget child;

  const EditableBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: borderGreen),
        borderRadius: BorderRadius.circular(17),
      ),
      child: child,
    );
  }
}

// Food card

class FoodCard extends StatelessWidget {
  final String name;
  final String amount;
  final bool warning;

  const FoodCard({
    super.key,
    required this.name,
    required this.amount,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: cream,
                    border: Border.all(color: borderGreen),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.edit_outlined,
                        color: darkGreen,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 13),
              const Icon(
                Icons.delete_outline,
                color: darkGreen,
                size: 22,
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: Text(
                  warning ? 'Est. portion · check' : 'Est. portion',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718071),
                  ),
                ),
              ),
              Container(
                width: 77,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cream,
                  border: Border.all(color: borderGreen),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textGreen,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 68,
                height: 44,
                decoration: BoxDecoration(
                  color: cream,
                  border: Border.all(color: borderGreen),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('g', style: TextStyle(color: textGreen)),
                    SizedBox(width: 7),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: darkGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Add food button

class AddFoodButton extends StatelessWidget {
  const AddFoodButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        foregroundColor: darkGreen,
        side: const BorderSide(color: borderGreen),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 21),
          SizedBox(width: 8),
          Text(
            'Add a missed food',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// Warning message

class PortionWarning extends StatelessWidget {
  const PortionWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E8B6),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: darkGreen, size: 21),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Avocado portion may need checking',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textGreen,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Check the amount before saving.',
                  style: TextStyle(fontSize: 13, color: textGreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Nutrition summary

class NutritionCard extends StatelessWidget {
  const NutritionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Estimated nutrition',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textGreen,
                  ),
                ),
              ),
              const Text(
                '520',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w700,
                  color: darkGreen,
                ),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'kcal',
                  style: TextStyle(fontSize: 12, color: textGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: MacroItem(
                  title: 'Protein',
                  amount: '40 g',
                  color: Color(0xFFE1E8D3),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: MacroItem(
                  title: 'Carbs',
                  amount: '54 g',
                  color: Color(0xFFF5E8B7),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: MacroItem(
                  title: 'Fat',
                  amount: '16 g',
                  color: Color(0xFFF3D8C9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Small nutrition item

class MacroItem extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const MacroItem({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: textGreen),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Confirm button

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: const Color(0xFFC5E34F),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 21),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Confirm & save',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              width: 39,
              height: 39,
              decoration: const BoxDecoration(
                color: Color(0xFFC5E34F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: darkGreen,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
