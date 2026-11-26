import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/theme/app_system_ui.dart';
import '../../../../core/widgets/app_floating_navigation_bar.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../widgets/recipe_details_widgets.dart';

/// Thin route screen for recipe details and culinary recommendations.
class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key});

  static const double _headerHeight = 165;

  void _onNavSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed('home');
        }
      case 1:
        AppToast.show(
          context,
          message: 'Meal Plan will be connected soon.',
          type: AppToastType.info,
        );
      case 2:
        break;
      case 3:
        AppToast.show(
          context,
          message: 'Progress will be connected soon.',
          type: AppToastType.info,
        );
      case 4:
        context.pushNamed('profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.greenHeader,
      child: AppOverlayScaffold(
        header: const RecipeDetailsHeader(headerHeight: _headerHeight),
        body: const _RecipeDetailsBody(headerHeight: _headerHeight),
        foreground: Positioned(
          left: AppResponsive.value(context, 14),
          right: AppResponsive.value(context, 14),
          bottom: AppResponsive.value(context, 8),
          child: AppFloatingNavigationBar(
            selectedIndex: 2,
            onSelected: (index) => _onNavSelected(context, index),
          ),
        ),
      ),
    );
  }
}

class _RecipeDetailsBody extends StatelessWidget {
  const _RecipeDetailsBody({required this.headerHeight});

  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final topPadding =
        AppOverlayScaffold.contentTop(context, headerHeight) +
        AppResponsive.value(context, 14);
    final bottomPadding = AppResponsive.value(context, 90);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.value(context, 18),
        topPadding,
        AppResponsive.value(context, 18),
        bottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RecipeHeroCard(),
          SizedBox(height: AppResponsive.value(context, 14)),
          const RecipeTitleSection(),
          SizedBox(height: AppResponsive.value(context, 14)),
          const RecipeNutritionBreakdownCard(),
          SizedBox(height: AppResponsive.value(context, 16)),
          const RecipeIngredientsSection(),
          SizedBox(height: AppResponsive.value(context, 16)),
          const RecipeCookingStepsSection(),
          SizedBox(height: AppResponsive.value(context, 18)),
          const RecipeActionSection(),
        ],
      ),
    );
  }
}
