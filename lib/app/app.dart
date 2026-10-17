import 'package:flutter/material.dart';

import 'observer/app_bloc_observer.dart';
import 'router/app_router.dart';
import '../core/theme/app_theme.dart';

/// Root application widget.
///
/// Feature-specific repositories and blocs will be registered here as the
/// corresponding features are implemented. Keeping this composition root in
/// one place prevents dependencies from leaking into presentation widgets.
class NutriVisionApp extends StatelessWidget {
  const NutriVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'NutriVision',
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}

/// Shared access point for the app-level observer configuration.
///
/// The observer is installed from [main] so tests can replace it when needed.
final appBlocObserver = AppBlocObserver();
