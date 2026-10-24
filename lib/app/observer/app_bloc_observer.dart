import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Central observer for Bloc/Cubit lifecycle events.
///
/// It stays quiet in release builds and gives us one place to add crash
/// reporting later without coupling feature blocs to a logging service.
class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('[${bloc.runtimeType}] $error');
    }
    super.onError(bloc, error, stackTrace);
  }
}
