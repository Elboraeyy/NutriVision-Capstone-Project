import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_action_button.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_widgets.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 1,
      title: 'Your goal',
      subtitle: 'What would you like to focus on? Choose one.',
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return OnboardingContent(
            children: [
              ...onboardingGoalOptions.map(
                (option) => Padding(
                  padding: EdgeInsets.only(
                    bottom: AppResponsive.value(context, 8),
                  ),
                  child: OnboardingGoalOption(
                    option: option,
                    selected: state.profile.goal == option.title,
                    onTap: () => context.read<OnboardingBloc>().add(
                      GoalSelected(option.title),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.value(context, 3)),
              Text(
                'A starting point, not a strict rule. We’ll keep your preferences\nand restrictions in mind.',
                textAlign: TextAlign.center,
                style: onboardingBodyStyle(context),
              ),
              const Spacer(),
              Text(
                'You can change your goal anytime in your profile.',
                textAlign: TextAlign.center,
                style: onboardingBodyStyle(context),
              ),
              SizedBox(height: AppResponsive.value(context, 10)),
              AppActionButton(
                label: 'Continue',
                onPressed: () => context.pushNamed('food-preferences'),
              ),
              SizedBox(height: AppResponsive.value(context, 12)),
            ],
          );
        },
      ),
    );
  }
}
