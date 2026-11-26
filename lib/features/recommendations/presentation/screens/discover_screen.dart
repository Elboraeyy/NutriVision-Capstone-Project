import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_floating_navigation_bar.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../bloc/recommendations_bloc.dart';
import '../widgets/discover_widgets.dart';

/// Main Discover screen matching Figma node 206:6851.
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationsBloc, RecommendationsState>(
      builder: (context, state) {
        final featured = state.featuredRecipe;
        final everydayRecipes = state.recipes
            .where((r) => r.id != featured?.id)
            .toList();
        final headerHeight = AppOverlayScaffold.contentTop(context, 125);

        return AppOverlayScaffold(
          header: DiscoverHeader(
            title: 'A little inspiration.',
            subtitle: 'Good food, made for your everyday.',
            savedCount: state.savedRecipes.length,
            onSavedTap: () => context.pushNamed('saved-recipes'),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppResponsive.value(context, 20),
              headerHeight + AppResponsive.value(context, 16),
              AppResponsive.value(context, 20),
              AppResponsive.value(context, 100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DiscoverSearchBar(
                  readOnly: true,
                  onTap: () => context.pushNamed('recipe-search'),
                  onFilterTap: () => context.pushNamed('recipe-search'),
                ),
                SizedBox(height: AppResponsive.value(context, 14)),
                const PreferenceNotice(),
                SizedBox(height: AppResponsive.value(context, 22)),
                if (featured != null) ...[
                  FeaturedRecipeCard(
                    recipe: featured,
                    onTap: () {
                      context.read<RecommendationsBloc>().add(
                        RecipeDetailsRequested(featured.id),
                      );
                      context.pushNamed(
                        'recipe-details',
                        pathParameters: {'id': featured.id},
                      );
                    },
                    onSaveTap: () {
                      context.read<RecommendationsBloc>().add(
                        RecipeSaveToggled(featured.id),
                      );
                      AppToast.show(
                        context,
                        message: featured.isSaved
                            ? 'Removed from saved recipes'
                            : 'Saved to favorites',
                        type: AppToastType.success,
                      );
                    },
                  ),
                  SizedBox(height: AppResponsive.value(context, 24)),
                ],
                if (everydayRecipes.isNotEmpty) ...[
                  Text(
                    'Everyday recipes',
                    style: TextStyle(
                      color: const Color(0xFF203E30),
                      fontSize: AppResponsive.font(context, 17),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 12)),
                  ...everydayRecipes.map((recipe) {
                    return EverydayRecipeCard(
                      recipe: recipe,
                      onTap: () {
                        context.read<RecommendationsBloc>().add(
                          RecipeDetailsRequested(recipe.id),
                        );
                        context.pushNamed(
                          'recipe-details',
                          pathParameters: {'id': recipe.id},
                        );
                      },
                      onSaveTap: () {
                        context.read<RecommendationsBloc>().add(
                          RecipeSaveToggled(recipe.id),
                        );
                        AppToast.show(
                          context,
                          message: recipe.isSaved
                              ? 'Removed from saved recipes'
                              : 'Saved to favorites',
                          type: AppToastType.success,
                        );
                      },
                    );
                  }),
                  SizedBox(height: AppResponsive.value(context, 16)),
                ],
                ChatWithAiBanner(
                  onTap: () {
                    AppToast.show(
                      context,
                      message:
                          'AI Nutrition Assistant is ready to recommend personalized meals!',
                      type: AppToastType.info,
                    );
                  },
                ),
                SizedBox(height: AppResponsive.value(context, 32)),
              ],
            ),
          ),
          foreground: Positioned(
            left: AppResponsive.value(context, 14),
            right: AppResponsive.value(context, 14),
            bottom: AppResponsive.value(context, 8),
            child: AppFloatingNavigationBar(
              selectedIndex: 2,
              onSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/home');
                    break;
                  case 1:
                    context.go('/meal-plan');
                    break;
                  case 2:
                    break;
                  case 3:
                    context.go('/water-tracker');
                    break;
                  case 4:
                    context.go('/profile');
                    break;
                }
              },
            ),
          ),
        );
      },
    );
  }
}
