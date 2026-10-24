import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final int step;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: OnboardingHeader(
          step: step,
          title: title,
          subtitle: subtitle,
          onBack: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/welcome');
            }
          },
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(
            AppResponsive.value(context, 18),
            0,
            AppResponsive.value(context, 18),
            0,
          ),
          child: child,
        ),
      ),
    );
  }
}

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final int step;
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final horizontal = AppResponsive.value(context, 16);

    return Container(
      height: topInset + AppResponsive.value(context, 184),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppResponsive.value(context, 40)),
          bottomRight: Radius.circular(AppResponsive.value(context, 40)),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: topInset + AppResponsive.value(context, 6),
            left: AppResponsive.value(context, 5),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.value(context, 12),
                    vertical: AppResponsive.value(context, 10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: AppResponsive.value(context, 22),
                      ),
                      SizedBox(width: AppResponsive.value(context, 7)),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppResponsive.font(context, 13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: topInset + AppResponsive.value(context, 46),
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -AppResponsive.value(context, 32)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppResponsive.font(context, 27),
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                      SizedBox(height: AppResponsive.value(context, 7)),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.softGreen,
                          fontSize: AppResponsive.font(context, 11),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: horizontal,
            right: horizontal,
            bottom: AppResponsive.value(context, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'STEP $step OF 3',
                  style: TextStyle(
                    color: AppColors.lime,
                    fontSize: AppResponsive.font(context, 9),
                    fontWeight: FontWeight.w800,
                    letterSpacing: .25,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 4)),
                OnboardingProgressBar(step: step),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Container(
            height: AppResponsive.value(context, 3),
            margin: EdgeInsets.only(
              right: index == 2 ? 0 : AppResponsive.value(context, 5),
            ),
            decoration: BoxDecoration(
              color: index < step
                  ? AppColors.lime
                  : AppColors.softGreen.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: AppOverlayScaffold.contentTop(context, 184) + 16,
          ),
          sliver: SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingSectionLabel extends StatelessWidget {
  const OnboardingSectionLabel({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: AppResponsive.font(context, 14),
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 2)),
        Text(subtitle, style: onboardingBodyStyle(context)),
      ],
    );
  }
}

class OnboardingChoiceWrap extends StatelessWidget {
  const OnboardingChoiceWrap({
    super.key,
    required this.values,
    required this.selected,
    required this.onTap,
  });

  final List<String> values;
  final Set<String> selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppResponsive.value(context, 7),
      runSpacing: AppResponsive.value(context, 9),
      children: values
          .map(
            (value) => OnboardingChoiceChip(
              label: value,
              selected: selected.contains(value),
              onTap: () => onTap(value),
            ),
          )
          .toList(),
    );
  }
}

class OnboardingChoiceChip extends StatelessWidget {
  const OnboardingChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, selected ? 13 : 14),
            vertical: AppResponsive.value(context, 9),
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.green
                : AppColors.softGreen.withValues(alpha: .35),
            borderRadius: BorderRadius.circular(30),
            border: selected
                ? null
                : Border.all(color: AppColors.borderGreen, width: .7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(
                  Icons.check,
                  color: AppColors.lime,
                  size: AppResponsive.value(context, 14),
                ),
                SizedBox(width: AppResponsive.value(context, 3)),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalOptionData {
  const GoalOptionData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

const onboardingGoalOptions = [
  GoalOptionData(
    title: 'Lose Weight',
    description: 'Build habits around your weight goal',
    icon: Icons.trending_down_rounded,
    color: AppColors.softGreen,
  ),
  GoalOptionData(
    title: 'Maintain Weight',
    description: 'Find a rhythm that works for you',
    icon: Icons.horizontal_rule_rounded,
    color: AppColors.yellow,
  ),
  GoalOptionData(
    title: 'Gain Weight',
    description: 'Make meals part of your routine',
    icon: Icons.trending_up_rounded,
    color: AppColors.peach,
  ),
  GoalOptionData(
    title: 'Build Muscle',
    description: 'Support your training with food',
    icon: Icons.fitness_center_rounded,
    color: AppColors.softGreen,
  ),
  GoalOptionData(
    title: 'Eat healthier',
    description: 'Bring more balance to everyday meals',
    icon: Icons.spa_rounded,
    color: AppColors.lime,
  ),
];

class OnboardingGoalOption extends StatelessWidget {
  const OnboardingGoalOption({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final GoalOptionData option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          height: AppResponsive.value(context, 58),
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.value(context, 10),
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.green
                : AppColors.softGreen.withValues(alpha: .45),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Container(
                width: AppResponsive.value(context, 38),
                height: AppResponsive.value(context, 38),
                decoration: BoxDecoration(
                  color: selected ? AppColors.lime : option.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option.icon,
                  color: AppColors.green,
                  size: AppResponsive.value(context, 20),
                ),
              ),
              SizedBox(width: AppResponsive.value(context, 10)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.darkGreen,
                        fontSize: AppResponsive.font(context, 12),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: AppResponsive.value(context, 1)),
                    Text(
                      option.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected
                            ? AppColors.softGreen
                            : AppColors.mutedGreen,
                        fontSize: AppResponsive.font(context, 11),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: AppResponsive.value(context, 16),
                height: AppResponsive.value(context, 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.lime : AppColors.borderGreen,
                    width: 1.2,
                  ),
                  color: selected ? AppColors.lime : Colors.transparent,
                ),
                child: selected
                    ? Icon(
                        Icons.check,
                        size: AppResponsive.value(context, 11),
                        color: AppColors.green,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSafetyNotice extends StatelessWidget {
  const OnboardingSafetyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.value(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(AppResponsive.value(context, 19)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: AppColors.green,
                size: AppResponsive.value(context, 18),
              ),
              SizedBox(width: AppResponsive.value(context, 7)),
              Text(
                'Always check before eating',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: AppResponsive.font(context, 13),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: AppResponsive.value(context, 9)),
          Text(
            'We’ll keep these restrictions in your preferences. Always\ncheck labels and preparation details; suggestions can’t\nguarantee allergen-free food.',
            style: TextStyle(
              color: AppColors.mutedGreen,
              fontSize: AppResponsive.font(context, 12),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingTextLink extends StatelessWidget {
  const OnboardingTextLink({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.darkGreen,
          fontSize: AppResponsive.font(context, 11),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

TextStyle onboardingBodyStyle(BuildContext context) => TextStyle(
  color: AppColors.mutedGreen,
  fontSize: AppResponsive.font(context, 11),
  height: 1.25,
);
