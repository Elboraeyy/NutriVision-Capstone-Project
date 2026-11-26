import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_toast.dart';

/// Camera capture and gallery picker screen for scanning a meal.
class CameraScannerScreen extends StatelessWidget {
  const CameraScannerScreen({
    super.key,
    this.onBack,
    this.onChoosePhoto,
    this.onTakePhoto,
  });

  final VoidCallback? onBack;
  final VoidCallback? onChoosePhoto;
  final VoidCallback? onTakePhoto;

  static const Color _darkGreen = Color(0xFF285542);
  static const Color _background = Color(0xFFF7F4EC);
  static const Color _textGreen = Color(0xFF244637);
  static const Color _lightGreen = Color(0xFFE4E9D9);

  void _openAnalyzing(BuildContext context) {
    GoRouter.maybeOf(context)?.pushNamed('meal-analyzing');
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: onBack ?? () => Navigator.maybePop(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 16),
                        Text(
                          'Home',
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
                    'Scan your meal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A quick photo. A clearer food diary.',
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
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1547592180-85f173990554'
                            '?auto=format&fit=crop&w=900&q=85',
                            height: 390,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) {
                              return Container(
                                height: 390,
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
                          Positioned(
                            top: 18,
                            right: 18,
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: _darkGreen,
                              child: IconButton(
                                onPressed: () => AppToast.show(
                                  context,
                                  message:
                                      'Language selection will be available soon.',
                                  type: AppToastType.info,
                                ),
                                icon: const Icon(
                                  Icons.translate,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(
                                color: _darkGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '1×',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Keep the whole meal in view',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Good light helps us estimate portions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF788273), fontSize: 15),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap:
                                onChoosePhoto ?? () => _openAnalyzing(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _lightGreen,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.photo_library_outlined,
                                      size: 30,
                                      color: _darkGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Choose photo',
                                    style: TextStyle(
                                      color: _textGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: onTakePhoto ?? () => _openAnalyzing(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _darkGreen,
                                        width: 4,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 32,
                                      color: Color(0xFFB8D84A),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Take photo',
                                    style: TextStyle(
                                      color: _textGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "You'll review everything before saving.",
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
