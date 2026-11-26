import 'package:flutter/material.dart';

import '../../../../core/widgets/app_toast.dart';

const Color _darkGreen = Color(0xFF285341);
const Color _textGreen = Color(0xFF244438);
const Color _cream = Color(0xFFF7F4EC);
const Color _lightGreen = Color(0xFFEDF0E1);
const Color _borderGreen = Color(0xFFB8CBA3);

/// Meal review and portion adjustment screen for AI-detected or manual meals.
class MealScreen extends StatelessWidget {
  const MealScreen({super.key, this.onAddFood, this.onConfirm});

  final VoidCallback? onAddFood;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const _MealHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(19, 20, 19, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _MealInfo(),
                    const SizedBox(height: 20),
                    const Text(
                      'Foods & portions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Correct detected foods and portions before saving.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF718071)),
                    ),
                    const SizedBox(height: 10),
                    const _FoodCard(name: 'Grilled chicken', amount: '100'),
                    const SizedBox(height: 10),
                    const _FoodCard(name: 'Cooked quinoa', amount: '150'),
                    const SizedBox(height: 10),
                    const _FoodCard(
                      name: 'Avocado',
                      amount: '40',
                      warning: true,
                    ),
                    const SizedBox(height: 10),
                    const _FoodCard(name: 'Mixed vegetables', amount: '80'),
                    const SizedBox(height: 10),
                    _AddFoodButton(
                      onPressed:
                          onAddFood ??
                          () => AppToast.show(
                            context,
                            message:
                                'Custom food search will be available soon.',
                            type: AppToastType.info,
                          ),
                    ),
                    const SizedBox(height: 17),
                    const _PortionWarning(),
                    const SizedBox(height: 17),
                    const _MealNutritionCard(),
                    const SizedBox(height: 18),
                    const Text(
                      'Nutrition values are estimates, not medical advice.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF718071)),
                    ),
                    const SizedBox(height: 17),
                    _ConfirmButton(
                      onPressed:
                          onConfirm ??
                          () => AppToast.show(
                            context,
                            message: 'Meal saving will be connected soon.',
                            type: AppToastType.info,
                          ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Confirmed food updates Diary, Home and Progress together.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF718071)),
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

class _MealHeader extends StatelessWidget {
  const _MealHeader();

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
        color: _darkGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.maybePop(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
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
            style: TextStyle(fontSize: 14, color: Color(0xFFD5E0D9)),
          ),
        ],
      ),
    );
  }
}

class _MealInfo extends StatelessWidget {
  const _MealInfo();

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
                color: _lightGreen,
              ),
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.restaurant, size: 32, color: _darkGreen),
                ),
              ),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meal name',
                    style: TextStyle(fontSize: 13, color: Color(0xFF718071)),
                  ),
                  SizedBox(height: 6),
                  _EditableBox(
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
                              color: _textGreen,
                            ),
                          ),
                        ),
                        Icon(Icons.edit_outlined, size: 20, color: _darkGreen),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 17),
        const Row(
          children: [
            Expanded(
              child: _EditableBox(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Dinner',
                        style: TextStyle(color: _textGreen, fontSize: 14),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: _darkGreen),
                  ],
                ),
              ),
            ),
            SizedBox(width: 9),
            Expanded(
              child: _EditableBox(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Today · 6:30 PM',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _textGreen, fontSize: 13),
                      ),
                    ),
                    Icon(Icons.edit_outlined, size: 19, color: _darkGreen),
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

class _EditableBox extends StatelessWidget {
  const _EditableBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: _borderGreen),
        borderRadius: BorderRadius.circular(17),
      ),
      child: child,
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    required this.name,
    required this.amount,
    this.warning = false,
  });

  final String name;
  final String amount;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
      decoration: BoxDecoration(
        color: _lightGreen,
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
                    color: _cream,
                    border: Border.all(color: _borderGreen),
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
                            color: _textGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.edit_outlined,
                        color: _darkGreen,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 13),
              const Icon(Icons.delete_outline, color: _darkGreen, size: 22),
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
                  color: _cream,
                  border: Border.all(color: _borderGreen),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textGreen,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 68,
                height: 44,
                decoration: BoxDecoration(
                  color: _cream,
                  border: Border.all(color: _borderGreen),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('g', style: TextStyle(color: _textGreen)),
                    SizedBox(width: 7),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: _darkGreen,
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

class _AddFoodButton extends StatelessWidget {
  const _AddFoodButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        foregroundColor: _darkGreen,
        side: const BorderSide(color: _borderGreen),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

class _PortionWarning extends StatelessWidget {
  const _PortionWarning();

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
          Icon(Icons.error_outline, color: _darkGreen, size: 21),
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
                    color: _textGreen,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Check the amount before saving.',
                  style: TextStyle(fontSize: 13, color: _textGreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealNutritionCard extends StatelessWidget {
  const _MealNutritionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Estimated nutrition',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textGreen,
                  ),
                ),
              ),
              Text(
                '520',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w700,
                  color: _darkGreen,
                ),
              ),
              SizedBox(width: 4),
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'kcal',
                  style: TextStyle(fontSize: 12, color: _textGreen),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MacroItem(
                  title: 'Protein',
                  amount: '40 g',
                  color: Color(0xFFE1E8D3),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MacroItem(
                  title: 'Carbs',
                  amount: '54 g',
                  color: Color(0xFFF5E8B7),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MacroItem(
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

class _MacroItem extends StatelessWidget {
  const _MacroItem({
    required this.title,
    required this.amount,
    required this.color,
  });

  final String title;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: _textGreen)),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkGreen,
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
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              width: 39,
              height: 39,
              decoration: const BoxDecoration(
                color: Color(0xFFC5E34F),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: _darkGreen, size: 25),
            ),
          ],
        ),
      ),
    );
  }
}
