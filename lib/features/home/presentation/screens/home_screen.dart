import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../bloc/home_bloc.dart';
import '../../domain/entities/home_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
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
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.08)),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppSystemUi.greenHeader,
            child: AppOverlayScaffold(
              header: _HomeHeader(dashboard: dashboard),
              body: _HomeBody(
                dashboard: dashboard,
                onScanMeal: () => _showComingSoon(context, 'Meal scan'),
                selectedTab: state.selectedTab,
                onTabSelected: (index) {
                  context.read<HomeBloc>().add(HomeTabSelected(index));
                  if (index != 0) {
                    _showComingSoon(context, _navigationItems[index].label);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$feature will be connected soon.'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
      ),
    );
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.dashboard,
    required this.onScanMeal,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final VoidCallback onScanMeal;
  final HomeDashboard dashboard;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final headerHeight = AppOverlayScaffold.contentTop(context, 165);
    final nutritionHeight = AppResponsive.value(context, 212);
    final overlap = AppResponsive.value(context, 40);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: _HomeContent(
            dashboard: dashboard,
            onScanMeal: onScanMeal,
            topPadding: headerHeight + nutritionHeight - overlap,
          ),
        ),
        Positioned(
          top: headerHeight - overlap,
          left: AppResponsive.value(context, 20),
          right: AppResponsive.value(context, 20),
          child: SizedBox(
            height: nutritionHeight,
            child: _NutritionCard(summary: dashboard.nutrition),
          ),
        ),
        Positioned(
          left: AppResponsive.value(context, 14),
          right: AppResponsive.value(context, 14),
          bottom: AppResponsive.value(context, 8),
          child: _HomeNavigation(
            selectedIndex: selectedTab,
            onSelected: onTabSelected,
          ),
        ),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      height:
          MediaQuery.paddingOf(context).top + AppResponsive.value(context, 165),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 22),
        topInset + AppResponsive.value(context, 14),
        AppResponsive.value(context, 22),
        AppResponsive.value(context, 24),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NutriVision',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppResponsive.font(context, 14),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                width: AppResponsive.value(context, 40),
                height: AppResponsive.value(context, 40),
                decoration: BoxDecoration(
                  color: AppColors.peach,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.green,
                  size: AppResponsive.value(context, 22),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 8)),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: AppResponsive.font(context, 28),
                fontWeight: FontWeight.w300,
                height: 1.1,
              ),
              children: [
                const TextSpan(text: 'Good afternoon, '),
                TextSpan(
                  text: dashboard.greetingName,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 3)),
          Text(
            dashboard.dayLabel,
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: AppResponsive.font(context, 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.dashboard,
    required this.onScanMeal,
    required this.topPadding,
  });

  final HomeDashboard dashboard;
  final VoidCallback onScanMeal;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppResponsive.value(context, 20),
            topPadding + AppResponsive.value(context, 16),
            AppResponsive.value(context, 20),
            AppResponsive.value(context, 118),
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _ScanMealButton(onPressed: onScanMeal),
              SizedBox(height: AppResponsive.value(context, 9)),
              _ManualLogButton(),
              SizedBox(height: AppResponsive.value(context, 12)),
              _WaterCard(summary: dashboard.water),
              SizedBox(height: AppResponsive.value(context, 16)),
              const _SectionHeading(
                title: 'Recently logged',
                action: 'Diary ↗',
              ),
              SizedBox(height: AppResponsive.value(context, 8)),
              _RecentMealCard(meal: dashboard.recentMeal),
              SizedBox(height: AppResponsive.value(context, 14)),
              _AiSuggestionCard(suggestion: dashboard.suggestion),
            ]),
          ),
        ),
      ],
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({required this.summary});

  final NutritionSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today’s nutrition',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 14),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'From logged food',
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 10),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 11)),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _CaloriesRing(
                  consumedCalories: summary.consumedCalories,
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NutritionNumber(
                      value: '${summary.remainingCalories}',
                      unit: 'kcal',
                      label: 'remaining',
                    ),
                    _NutritionNumber(
                      value: '${summary.goalCalories}',
                      unit: 'kcal',
                      label: 'Goal',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 10)),
          Row(
            children: [
              Expanded(
                child: _MacroPill(
                  label: summary.protein.label,
                  value:
                      '${summary.protein.consumed} / ${summary.protein.goal} g',
                  color: AppColors.cream,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: _MacroPill(
                  label: summary.carbs.label,
                  value: '${summary.carbs.consumed} / ${summary.carbs.goal} g',
                  color: AppColors.yellow,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: _MacroPill(
                  label: summary.fat.label,
                  value: '${summary.fat.consumed} / ${summary.fat.goal} g',
                  color: AppColors.peach,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CaloriesRing extends StatelessWidget {
  const _CaloriesRing({required this.consumedCalories});

  final int consumedCalories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppResponsive.value(context, 90),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: AppResponsive.value(context, 90),
            height: AppResponsive.value(context, 90),
            child: CircularProgressIndicator(
              value: .62,
              strokeWidth: AppResponsive.value(context, 2.5),
              backgroundColor: AppColors.borderGreen.withValues(alpha: .5),
              color: AppColors.borderGreen,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                consumedCalories.toStringAsFixed(0),
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: AppResponsive.font(context, 22),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'kcal consumed',
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutritionNumber extends StatelessWidget {
  const _NutritionNumber({
    required this.value,
    required this.unit,
    required this.label,
  });

  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                color: AppColors.green,
                fontSize: AppResponsive.font(context, 22),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(width: AppResponsive.value(context, 3)),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                unit,
                style: TextStyle(
                  color: AppColors.mutedGreen,
                  fontSize: AppResponsive.font(context, 10),
                ),
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.mutedGreen,
            fontSize: AppResponsive.font(context, 10),
          ),
        ),
      ],
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 8),
        vertical: AppResponsive.value(context, 7),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 10),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: AppResponsive.font(context, 10),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanMealButton extends StatelessWidget {
  const _ScanMealButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _FilledPillButton(
      label: 'Scan a meal',
      icon: Icons.center_focus_weak_rounded,
      onPressed: onPressed,
    );
  }
}

class _FilledPillButton extends StatelessWidget {
  const _FilledPillButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          height: AppResponsive.value(context, 50),
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, 12),
          ),
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.lime, size: 18),
              SizedBox(width: AppResponsive.value(context, 7)),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.lime,
                    fontSize: AppResponsive.font(context, 13),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: AppColors.lime),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManualLogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.value(context, 40),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGreen),
        borderRadius: BorderRadius.circular(100),
      ),
      alignment: Alignment.center,
      child: Text(
        '+  Log food manually',
        style: TextStyle(
          color: AppColors.darkGreen,
          fontSize: AppResponsive.font(context, 11),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  const _WaterCard({required this.summary});

  final WaterSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 12),
        vertical: AppResponsive.value(context, 13),
      ),
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 21)),
      ),
      child: Row(
        children: [
          Icon(Icons.water_drop_outlined, color: AppColors.green, size: 22),
          SizedBox(width: AppResponsive.value(context, 5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: AppResponsive.font(context, 9),
                    ),
                    children: [
                      const TextSpan(
                        text: 'Water ',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: '${summary.consumedMl} / ${summary.goalMl} ml',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 5)),
                Row(
                  children: List.generate(
                    6,
                    (index) => Expanded(
                      child: Container(
                        height: 6,
                        margin: EdgeInsets.only(
                          right: index == 5
                              ? 0
                              : AppResponsive.value(context, 3),
                        ),
                        decoration: BoxDecoration(
                          color:
                              index < (summary.consumedMl / summary.goalMl * 6)
                              ? AppColors.green
                              : AppColors.borderGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppResponsive.value(context, 8)),
          Container(
            width: AppResponsive.value(context, 44),
            height: AppResponsive.value(context, 44),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
            child: Text(
              '+250 ml',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppResponsive.font(context, 10),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: AppResponsive.font(context, 14),
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          action,
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: AppResponsive.font(context, 10),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RecentMealCard extends StatelessWidget {
  const _RecentMealCard({required this.meal});

  final RecentMeal meal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 15)),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 21)),
      ),
      child: Row(
        children: [
          Container(
            width: AppResponsive.value(context, 66),
            height: AppResponsive.value(context, 66),
            decoration: BoxDecoration(
              color: AppColors.peach,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.restaurant, color: AppColors.green),
          ),
          SizedBox(width: AppResponsive.value(context, 9)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.time,
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 10),
                  ),
                ),
                Text(
                  meal.title,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 14),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Est. ${meal.calories} kcal',
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 10),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.green),
        ],
      ),
    );
  }
}

class _AiSuggestionCard extends StatelessWidget {
  const _AiSuggestionCard({required this.suggestion});

  final MealSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 20)),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI suggestion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppResponsive.font(context, 11),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  suggestion.tag,
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: AppResponsive.font(context, 7),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 9)),
          Text(
            suggestion.title.replaceFirst(' & ', ' &\n'),
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.font(context, 22),
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 9)),
          Text(
            suggestion.description,
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: AppResponsive.font(context, 10),
              height: 1.35,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 9)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Est. ${suggestion.calories} kcal · ${suggestion.proteinGrams} g protein\n${suggestion.carbsGrams} g carbs · ${suggestion.fatGrams} g fat',
                style: TextStyle(
                  color: AppColors.softGreen,
                  fontSize: AppResponsive.font(context, 10),
                  height: 1.35,
                ),
              ),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.lime,
                  foregroundColor: AppColors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.value(context, 10),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Add to diary ✓',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeNavigation extends StatelessWidget {
  const _HomeNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.value(context, 54),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.value(context, 4),
        vertical: AppResponsive.value(context, 2),
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
        children: List.generate(
          _navigationItems.length,
          (index) => Expanded(
            child: _HomeNavItem(
              item: _navigationItems[index],
              selected: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavigationItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1 : .96,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.value(context, 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.value(context, selected ? 7 : 2),
                vertical: AppResponsive.value(context, 2),
              ),
              decoration: BoxDecoration(
                color: selected ? AppColors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      selected ? item.selectedIcon : item.icon,
                      key: ValueKey(selected),
                      color: selected ? Colors.white : AppColors.darkGreen,
                      size: AppResponsive.value(context, 17),
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 1)),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.darkGreen,
                      fontSize: AppResponsive.font(context, 8),
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    ),
                    child: Text(item.label, maxLines: 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _navigationItems = [
  _NavigationItem(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  _NavigationItem(
    label: 'Meal Plan',
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_month_rounded,
  ),
  _NavigationItem(
    label: 'Discover',
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore_rounded,
  ),
  _NavigationItem(
    label: 'Progress',
    icon: Icons.insights_outlined,
    selectedIcon: Icons.insights_rounded,
  ),
  _NavigationItem(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
  ),
];
