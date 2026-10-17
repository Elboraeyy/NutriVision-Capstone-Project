import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_action_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_widgets.dart';

class AllergiesScreen extends StatelessWidget {
  const AllergiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 3,
      title: 'Allergies',
      subtitle: 'Tell us what to leave out. These aren’t food dislikes.',
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.status == OnboardingStatus.completed) {
            AppToast.show(
              context,
              message: 'Your preferences were saved successfully.',
              type: AppToastType.success,
            );
            context.go('/splash?destination=home');
          } else if (state.status == OnboardingStatus.failure) {
            AppToast.show(
              context,
              message: state.message ?? 'Unable to save onboarding.',
              type: AppToastType.error,
            );
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) => OnboardingContent(
            children: [
              const OnboardingSectionLabel(
                title: 'Common allergens',
                subtitle: 'Select all that apply, or select None.',
              ),
              SizedBox(height: AppResponsive.value(context, 8)),
              OnboardingChoiceWrap(
                values: const [
                  'Peanuts',
                  'Tree nuts',
                  'Milk',
                  'Eggs',
                  'Wheat',
                  'Soy',
                  'Fish',
                  'Shellfish',
                  'Sesame',
                  'None',
                ],
                selected: state.profile.noAllergies
                    ? {'None'}
                    : state.profile.allergies,
                onTap: (value) =>
                    context.read<OnboardingBloc>().add(AllergyToggled(value)),
              ),
              SizedBox(height: AppResponsive.value(context, 12)),
              Text(
                'Choosing None clears the allergen selections above.',
                style: onboardingBodyStyle(context),
              ),
              SizedBox(height: AppResponsive.value(context, 15)),
              const OnboardingSafetyNotice(),
              const Spacer(),
              Text(
                state.profile.noAllergies || state.profile.allergies.isEmpty
                    ? 'Saved: no food allergies'
                    : 'Saved: ${state.profile.allergies.first.toLowerCase()} allergy · exclude alcohol',
                textAlign: TextAlign.center,
                style: onboardingBodyStyle(context),
              ),
              SizedBox(height: AppResponsive.value(context, 10)),
              AppActionButton(
                label: 'Save & go to Home',
                onPressed: () => context.read<OnboardingBloc>().add(
                  const OnboardingCompleted(),
                ),
              ),
              SizedBox(height: AppResponsive.value(context, 12)),
            ],
          ),
        ),
      ),
    );
  }
}
