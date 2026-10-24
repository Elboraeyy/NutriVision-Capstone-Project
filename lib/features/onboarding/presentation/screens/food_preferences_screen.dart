import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_action_button.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_widgets.dart';

class FoodPreferencesScreen extends StatelessWidget {
  const FoodPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 2,
      title: 'Food preferences',
      subtitle: 'A few favorites help us make this feel like you.',
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) => OnboardingContent(
          children: [
            const OnboardingSectionLabel(
              title: 'Dietary pattern',
              subtitle: 'Choose one, or leave it open.',
            ),
            SizedBox(height: AppResponsive.value(context, 7)),
            OnboardingChoiceWrap(
              values: const [
                'No preference',
                'Flexitarian',
                'Vegetarian',
                'Vegan',
                'Pescatarian',
              ],
              selected: state.profile.dietaryPreferences,
              onTap: (value) => context.read<OnboardingBloc>().add(
                DietaryPreferenceToggled(value),
              ),
            ),
            SizedBox(height: AppResponsive.value(context, 17)),
            const OnboardingSectionLabel(
              title: 'Favorite foods',
              subtitle: 'Choose a few. You can add your own.',
            ),
            SizedBox(height: AppResponsive.value(context, 7)),
            OnboardingChoiceWrap(
              values: const ['Oats', 'Berries', 'Salmon', 'Rice', 'Lentils'],
              selected: state.profile.favoriteFoods,
              onTap: (value) => context.read<OnboardingBloc>().add(
                FavoriteFoodToggled(value),
              ),
            ),
            const Spacer(),
            Text(
              'Optional. Skipping never clears allergy restrictions.',
              textAlign: TextAlign.center,
              style: onboardingBodyStyle(context),
            ),
            SizedBox(height: AppResponsive.value(context, 10)),
            AppActionButton(
              label: 'Continue',
              onPressed: () => context.pushNamed('allergies'),
            ),
            SizedBox(height: AppResponsive.value(context, 12)),
            OnboardingTextLink(
              label: 'Skip food preferences',
              onTap: () => context.pushNamed('allergies'),
            ),
            SizedBox(height: AppResponsive.value(context, 9)),
          ],
        ),
      ),
    );
  }
}
