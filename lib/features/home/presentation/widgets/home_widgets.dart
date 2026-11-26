part of '../screens/home_screen.dart';

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
  const _HomeHeader({required this.dashboard, required this.userName});

  final HomeDashboard dashboard;
  final String? userName;

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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              maxLines: 1,
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
                    text: userName?.trim().isNotEmpty == true
                        ? userName!.trim()
                        : 'Mohamed',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
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
              _ManualLogButton(
                onPressed: () => context.pushNamed('meal-review'),
              ),
              SizedBox(height: AppResponsive.value(context, 12)),
              const _WaterCard(),
              SizedBox(height: AppResponsive.value(context, 16)),
              const _SectionHeading(title: 'Recently logged', action: 'Diary'),
              SizedBox(height: AppResponsive.value(context, 8)),
              _RecentMealCard(
                meal: dashboard.recentMeal,
                onTap: () => context.pushNamed('meal-details'),
              ),
              SizedBox(height: AppResponsive.value(context, 14)),
              _AiSuggestionCard(
                suggestion: dashboard.suggestion,
                onTap: () => context.pushNamed('recipe-details'),
              ),
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
              Expanded(
                child: Text(
                  'Today’s nutrition',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 14),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'From logged food',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.mutedGreen,
                    fontSize: AppResponsive.font(context, 10),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 11)),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _CaloriesRing(
                      consumedCalories: summary.consumedCalories,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: _NutritionNumber(
                          value: '${summary.remainingCalories}',
                          unit: 'kcal',
                          label: 'remaining',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: _NutritionNumber(
                          value: '${summary.goalCalories}',
                          unit: 'kcal',
                          label: 'Goal',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              const SizedBox(width: 5),
              Expanded(
                child: _MacroPill(
                  label: summary.carbs.label,
                  value: '${summary.carbs.consumed} / ${summary.carbs.goal} g',
                  color: AppColors.yellow,
                ),
              ),
              const SizedBox(width: 5),
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
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
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
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 10),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: AppResponsive.font(context, 10),
                fontWeight: FontWeight.w700,
              ),
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
  Widget build(BuildContext context) => _FilledPillButton(
    label: 'Scan a meal',
    icon: Icons.center_focus_weak_rounded,
    onPressed: onPressed,
  );
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
  const _ManualLogButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          height: AppResponsive.value(context, 40),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderGreen),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              '+  Log food manually',
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: AppResponsive.font(context, 11),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  const _WaterCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterBloc, WaterState>(
      builder: (context, state) {
        final consumedMl = state.water.consumedMl;
        final goalMl = state.water.goalMl;
        final progress = state.water.progress;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.pushNamed('water-tracker'),
            borderRadius: BorderRadius.circular(
              AppResponsive.value(context, 21),
            ),
            child: Ink(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.value(context, 12),
                vertical: AppResponsive.value(context, 13),
              ),
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(
                  AppResponsive.value(context, 21),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.water_drop_outlined,
                    color: AppColors.green,
                    size: 22,
                  ),
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
                              TextSpan(text: '$consumedMl / $goalMl ml'),
                            ],
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 5)),
                        Row(
                          children: List.generate(
                            8,
                            (index) => Expanded(
                              child: Container(
                                height: 6,
                                margin: EdgeInsets.only(
                                  right: index == 7
                                      ? 0
                                      : AppResponsive.value(context, 3),
                                ),
                                decoration: BoxDecoration(
                                  color: index < (progress * 8)
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
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.read<WaterBloc>().add(const WaterAdded(250));
                        AppToast.show(
                          context,
                          message: 'Added 250 ml water',
                          type: AppToastType.success,
                        );
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Ink(
                        width: AppResponsive.value(context, 44),
                        height: AppResponsive.value(context, 44),
                        decoration: const BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              action,
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: AppResponsive.font(context, 10),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: AppResponsive.value(context, 2)),
            Icon(
              Icons.open_in_new_rounded,
              color: AppColors.darkGreen,
              size: AppResponsive.value(context, 10),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecentMealCard extends StatelessWidget {
  const _RecentMealCard({required this.meal, required this.onTap});

  final RecentMeal meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      AppResponsive.value(context, 21),
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          padding: EdgeInsets.all(AppResponsive.value(context, 15)),
          decoration: BoxDecoration(
            color: AppColors.yellow,
            borderRadius: borderRadius,
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
        ),
      ),
    );
  }
}

class _AiSuggestionCard extends StatelessWidget {
  const _AiSuggestionCard({required this.suggestion, required this.onTap});

  final MealSuggestion suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      AppResponsive.value(context, 24),
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          padding: EdgeInsets.all(AppResponsive.value(context, 20)),
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: borderRadius,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
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
                  Expanded(
                    child: Text(
                      'Est. ${suggestion.calories} kcal · ${suggestion.proteinGrams} g protein\n${suggestion.carbsGrams} g carbs · ${suggestion.fatGrams} g fat',
                      style: TextStyle(
                        color: AppColors.softGreen,
                        fontSize: AppResponsive.font(context, 10),
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => AppToast.show(
                      context,
                      message:
                          'Adding meals to your diary will be available soon.',
                      type: AppToastType.info,
                    ),
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
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    return AppFloatingNavigationBar(
      selectedIndex: selectedIndex,
      onSelected: onSelected,
    );
  }
}
