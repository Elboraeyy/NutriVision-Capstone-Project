import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_toast.dart';
import '../bloc/water_bloc.dart';
import '../widgets/custom_water_input_section.dart';
import '../widgets/quick_add_water_section.dart';
import '../widgets/water_progress_card.dart';

class WaterTrackerScreen extends StatelessWidget {
  const WaterTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: BlocConsumer<WaterBloc, WaterState>(
        listener: (context, state) {
          if (state.status == WaterStatus.failure && state.message != null) {
            AppToast.show(
              context,
              message: state.message!,
              type: AppToastType.error,
            );
          }
        },
        builder: (context, state) {
          final overlap = AppResponsive.value(context, 24);

          return Scaffold(
            backgroundColor: AppColors.cream,
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _WaterTrackerHeader(
                            onBack: () {
                              if (Navigator.of(context).canPop()) {
                                context.pop();
                              } else {
                                context.goNamed('home');
                              }
                            },
                          ),
                          Transform.translate(
                            offset: Offset(0, -overlap),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                AppResponsive.value(context, 20),
                                0,
                                AppResponsive.value(context, 20),
                                AppResponsive.value(context, 100),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WaterProgressCard(water: state.water),
                                  SizedBox(
                                    height: AppResponsive.value(context, 20),
                                  ),
                                  QuickAddWaterSection(
                                    selectedAmountMl: state.selectedQuickAddMl,
                                    onAddWater: (amount) {
                                      context.read<WaterBloc>().add(
                                        WaterAdded(amount),
                                      );
                                      AppToast.show(
                                        context,
                                        message: 'Added $amount ml water',
                                        type: AppToastType.success,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: AppResponsive.value(context, 20),
                                  ),
                                  CustomWaterInputSection(
                                    onAddWater: (amount) {
                                      context.read<WaterBloc>().add(
                                        WaterAdded(amount),
                                      );
                                      AppToast.show(
                                        context,
                                        message: 'Added $amount ml water',
                                        type: AppToastType.success,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppResponsive.value(context, 14),
                    right: AppResponsive.value(context, 14),
                    bottom: AppResponsive.value(context, 8),
                    child: _WaterTrackerBottomNavigation(
                      onHomeTap: () {
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        } else {
                          context.goNamed('home');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WaterTrackerHeader extends StatelessWidget {
  const _WaterTrackerHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final formattedDate = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 18),
        topInset + AppResponsive.value(context, 10),
        AppResponsive.value(context, 18),
        AppResponsive.value(context, 44),
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 38)),
          bottomRight: Radius.circular(AppResponsive.value(context, 38)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.value(context, 6),
                      vertical: AppResponsive.value(context, 4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: AppResponsive.value(context, 6)),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppResponsive.font(context, 14),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: AppResponsive.value(context, 38),
                height: AppResponsive.value(context, 38),
                decoration: BoxDecoration(
                  color: AppColors.peach,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.green,
                  size: AppResponsive.value(context, 20),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 14)),
          Text(
            'Every sip counts.',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.font(context, 28),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 4)),
          Text(
            'Water tracker · $formattedDate',
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: AppResponsive.font(context, 12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterTrackerBottomNavigation extends StatelessWidget {
  const _WaterTrackerBottomNavigation({required this.onHomeTap});

  final VoidCallback onHomeTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.value(context, 64),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 6),
        vertical: AppResponsive.value(context, 4),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(alpha: .14),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _BottomNavItem(
              label: 'Home',
              icon: Icons.home_rounded,
              selected: true,
              onTap: onHomeTap,
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              label: 'Meal Plan',
              icon: Icons.calendar_today_outlined,
              selected: false,
              onTap: () => AppToast.show(
                context,
                message: 'Meal Plan will be connected soon.',
                type: AppToastType.info,
              ),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              label: 'Discover',
              icon: Icons.explore_outlined,
              selected: false,
              onTap: () => AppToast.show(
                context,
                message: 'Discover will be connected soon.',
                type: AppToastType.info,
              ),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              label: 'Progress',
              icon: Icons.insights_outlined,
              selected: false,
              onTap: () => AppToast.show(
                context,
                message: 'Progress will be connected soon.',
                type: AppToastType.info,
              ),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              label: 'Profile',
              icon: Icons.person_outline_rounded,
              selected: false,
              onTap: () => context.pushNamed('profile'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, selected ? 8 : 2),
            vertical: AppResponsive.value(context, selected ? 6 : 2),
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : AppColors.darkGreen,
                size: AppResponsive.value(context, 18),
              ),
              SizedBox(height: AppResponsive.value(context, 1)),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 8),
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
