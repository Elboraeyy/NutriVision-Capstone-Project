import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_responsive.dart';

/// Item definition for the floating navigation bar.
class AppFloatingNavigationItem {
  const AppFloatingNavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// The canonical 5 navigation items used across NutriVision.
const List<AppFloatingNavigationItem> kAppNavigationItems = [
  AppFloatingNavigationItem(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  AppFloatingNavigationItem(
    label: 'Meal Plan',
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_month_rounded,
  ),
  AppFloatingNavigationItem(
    label: 'Discover',
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore_rounded,
  ),
  AppFloatingNavigationItem(
    label: 'Progress',
    icon: Icons.insights_outlined,
    selectedIcon: Icons.insights_rounded,
  ),
  AppFloatingNavigationItem(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
  ),
];

/// Canonical floating pill navigation bar used in NutriVision.
class AppFloatingNavigationBar extends StatelessWidget {
  const AppFloatingNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.items = kAppNavigationItems,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<AppFloatingNavigationItem> items;

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
          items.length,
          (index) => Expanded(
            child: _AppFloatingNavItem(
              item: items[index],
              selected: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppFloatingNavItem extends StatelessWidget {
  const _AppFloatingNavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppFloatingNavigationItem item;
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
            borderRadius: BorderRadius.circular(100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.value(context, selected ? 7 : 2),
                vertical: AppResponsive.value(context, selected ? 5 : 2),
              ),
              decoration: BoxDecoration(
                color: selected ? AppColors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
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
