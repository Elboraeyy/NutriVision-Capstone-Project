import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/bloc/auth_session_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.displayDuration = const Duration(milliseconds: 1200),
    this.destination,
  });

  final Duration displayDuration;
  final String? destination;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _minimumDurationElapsed = false;
  bool _sessionResolved = false;
  bool _hasNavigated = false;
  AuthSessionStatus? _resolvedStatus;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _scaleAnimation = Tween<double>(begin: .82, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .12),
      end: Offset.zero,
    ).animate(curvedAnimation);
    _animationController.forward();
    _timer = Timer(widget.displayDuration, () {
      _minimumDurationElapsed = true;
      _maybeOpenNextRoute();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthSessionBloc>().add(const AuthSessionRestoreRequested());
    });
  }

  void _maybeOpenNextRoute() {
    if (!mounted ||
        _hasNavigated ||
        !_minimumDurationElapsed ||
        !_sessionResolved) {
      return;
    }

    _hasNavigated = true;
    final shouldOpenHome =
        widget.destination == 'home' ||
        _resolvedStatus == AuthSessionStatus.signedIn;
    if (shouldOpenHome) {
      context.go('/home');
      return;
    }

    final repository = context.read<AuthRepository>();
    if (!repository.hasSeenWelcome) {
      unawaited(repository.markWelcomeSeen());
      context.go('/welcome');
    } else {
      context.go('/sign-in');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = AppResponsive.scale(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenScreen,
      child: BlocListener<AuthSessionBloc, AuthSessionState>(
        listener: (context, state) {
          if (state.status == AuthSessionStatus.signedIn ||
              state.status == AuthSessionStatus.signedOut ||
              state.status == AuthSessionStatus.failure) {
            _resolvedStatus = state.status;
            _sessionResolved = true;
            _maybeOpenNextRoute();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.green,
          body: ColoredBox(
            color: AppColors.green,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: SvgPicture.asset(
                          AppAssets.logo,
                          width: 213 * scale,
                          height: 168 * scale,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
