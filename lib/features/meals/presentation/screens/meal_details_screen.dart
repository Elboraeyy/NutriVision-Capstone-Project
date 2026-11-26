import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../widgets/meal_details_widgets.dart';

/// Thin route screen displaying logged meal details, macros, and ingredients.
class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  static const double _headerHeight = 165;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: const MealDetailsHeader(headerHeight: _headerHeight),
        body: const _MealDetailsBody(headerHeight: _headerHeight),
      ),
    );
  }
}

class _MealDetailsBody extends StatelessWidget {
  const _MealDetailsBody({required this.headerHeight});

  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final topPadding =
        AppOverlayScaffold.contentTop(context, headerHeight) +
        AppResponsive.value(context, 14);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 18),
        topPadding,
        AppResponsive.value(context, 18),
        AppResponsive.value(context, 32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MealHeroImage(),
          SizedBox(height: AppResponsive.value(context, 14)),
          const MealTitleSection(),
          SizedBox(height: AppResponsive.value(context, 16)),
          const MealNutritionBreakdownCard(),
          SizedBox(height: AppResponsive.value(context, 18)),
          const MealIngredientsSection(),
          SizedBox(height: AppResponsive.value(context, 16)),
          Text(
            'Nutrition is estimated from the listed foods and portions. '
            'Ingredients, brands and preparation can change the values.',
            style: TextStyle(
              fontSize: AppResponsive.font(context, 11),
              height: 1.45,
              color: AppColors.mutedGreen,
            ),
          ),
          SizedBox(height: AppResponsive.value(context, 20)),
          const MealActionButtons(),
          SizedBox(height: AppResponsive.value(context, 10)),
          Center(
            child: Text(
              'Nutrition estimates, not medical advice.',
              style: TextStyle(
                fontSize: AppResponsive.font(context, 11),
                color: AppColors.mutedGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
