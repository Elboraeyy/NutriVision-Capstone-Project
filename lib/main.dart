import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';

// Kept as a public export so existing tests and platform entry points can
// continue importing the root app from main.dart.
export 'app/app.dart' show NutriVisionApp;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = appBlocObserver;
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: const [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  runApp(const NutriVisionApp());
}
