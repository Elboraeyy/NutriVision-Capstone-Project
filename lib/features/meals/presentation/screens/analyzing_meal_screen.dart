import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Progress screen shown while an uploaded or captured meal photo is analyzed.
class AnalyzingMealScreen extends StatelessWidget {
  const AnalyzingMealScreen({super.key, this.onCancel, this.onContinue});

  final VoidCallback? onCancel;
  final VoidCallback? onContinue;

  static const Color _darkGreen = Color(0xFF285542);
  static const Color _background = Color(0xFFF7F4EC);
  static const Color _textGreen = Color(0xFF244637);
  static const Color _lightGreen = Color(0xFFEEF0E1);

  @override
  Widget build(BuildContext context) {
    final handleCancel = onCancel ?? () => Navigator.maybePop(context);

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              decoration: const BoxDecoration(
                color: _darkGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(65),
                  bottomRight: Radius.circular(65),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 38),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: handleCancel,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 16),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'A closer look',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Getting to know your meal.',
                    style: TextStyle(color: Color(0xFFD7E2D9), fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1547592180-85f173990554'
                        '?auto=format&fit=crop&w=900&q=85',
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return Container(
                            height: 300,
                            color: _lightGreen,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.restaurant,
                              size: 60,
                              color: _darkGreen,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 26),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _lightGreen,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 38,
                                height: 38,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _darkGreen,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Analyzing your photo...',
                                  style: TextStyle(
                                    color: _textGreen,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22),
                          Text(
                            'Identifying foods and estimating portions. '
                            'You can adjust the details next.',
                            style: TextStyle(
                              color: Color(0xFF788273),
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed:
                            onContinue ??
                            () => GoRouter.maybeOf(
                              context,
                            )?.pushNamed('meal-review'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _darkGreen,
                          foregroundColor: const Color(0xFFC5E34F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Text(
                          'Continue to review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: OutlinedButton(
                        onPressed: handleCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _darkGreen,
                          side: const BorderSide(
                            color: Color(0xFFB8C8A5),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Text(
                          'Cancel analysis',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Nothing has been added to your diary.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF788273), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: 145,
              height: 5,
              decoration: BoxDecoration(
                color: _textGreen,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
