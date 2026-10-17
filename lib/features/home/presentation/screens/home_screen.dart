import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../auth/presentation/bloc/auth_session_bloc.dart';
import '../../domain/entities/home_dashboard.dart';
import '../bloc/home_bloc.dart';

part '../widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .035),
      end: Offset.zero,
    ).animate(curvedAnimation);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.status == HomeStatus.failure) {
              AppToast.show(
                context,
                message: 'We could not load your dashboard. Please try again.',
                type: AppToastType.error,
              );
            }
          },
          builder: (context, state) {
            if (state.dashboard == null) {
              return Scaffold(
                backgroundColor: AppColors.cream,
                body: Center(
                  child: state.status == HomeStatus.failure
                      ? Text(state.message ?? 'Unable to load your dashboard.')
                      : const CircularProgressIndicator(color: AppColors.green),
                ),
              );
            }

            final dashboard = state.dashboard!;
            final userName = context.select(
              (AuthSessionBloc bloc) => bloc.state.user?.name,
            );
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.08)),
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: AppSystemUi.greenHeader,
                child: AppOverlayScaffold(
                  header: _HomeHeader(dashboard: dashboard, userName: userName),
                  body: _HomeBody(
                    dashboard: dashboard,
                    onScanMeal: () => _showComingSoon(context, 'Meal scan'),
                    selectedTab: state.selectedTab,
                    onTabSelected: (index) {
                      if (index == 4) {
                        context.read<HomeBloc>().add(const HomeTabSelected(0));
                        context.pushNamed('profile');
                      } else {
                        context.read<HomeBloc>().add(HomeTabSelected(index));
                      }
                      if (index != 0 && index != 4) {
                        _showComingSoon(context, _navigationItems[index].label);
                      }
                    },
                  ),
                  foreground: Positioned(
                    top:
                        AppOverlayScaffold.contentTop(context, 165) -
                        AppResponsive.value(context, 40),
                    left: AppResponsive.value(context, 20),
                    right: AppResponsive.value(context, 20),
                    child: SizedBox(
                      height: AppResponsive.value(context, 212),
                      child: _NutritionCard(summary: dashboard.nutrition),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _showComingSoon(BuildContext context, String feature) {
  AppToast.show(
    context,
    message: '$feature will be connected soon.',
    type: AppToastType.info,
    duration: const Duration(milliseconds: 2000),
  );
}
