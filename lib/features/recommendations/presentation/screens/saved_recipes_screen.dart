import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';
import '../../../../core/widgets/app_floating_navigation_bar.dart';
import '../../../../core/widgets/app_overlay_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../bloc/recommendations_bloc.dart';
import '../widgets/discover_widgets.dart';

/// Saved recipes bookmarks screen.
class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationsBloc, RecommendationsState>(
      builder: (context, state) {
        final saved = state.savedRecipes;

        return AppOverlayScaffold(
          header: DiscoverHeader(
            showBack: true,
            title: 'Saved recipes',
            subtitle: 'Your personal collection of culinary inspirations.',
            savedCount: saved.length,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.value(context, 20),
              vertical: AppResponsive.value(context, 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (saved.isEmpty)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: AppResponsive.value(context, 32),
                    ),
                    padding: EdgeInsets.all(AppResponsive.value(context, 24)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFDCE1D2)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: AppResponsive.value(context, 64),
                          height: AppResponsive.value(context, 64),
                          decoration: BoxDecoration(
                            color: AppColors.green.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bookmark_border_rounded,
                            size: 32,
                            color: AppColors.green,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 16)),
                        Text(
                          'No saved recipes yet',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 17),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppResponsive.value(context, 6)),
                        Text(
                          'Explore dishes and tap the bookmark icon to save your favorite meals here.',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 13),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppResponsive.value(context, 18)),
                        ElevatedButton.icon(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.explore_rounded,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Explore Recipes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppResponsive.value(context, 20),
                              vertical: AppResponsive.value(context, 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Text(
                    '${saved.length} Saved ${saved.length == 1 ? 'Meal' : 'Meals'}',
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: AppResponsive.font(context, 17),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: AppResponsive.value(context, 14)),
                  ...saved.map(
                    (recipe) => Padding(
                      padding: EdgeInsets.only(
                        bottom: AppResponsive.value(context, 12),
                      ),
                      child: EverydayRecipeCard(
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
                            message: 'Removed from saved recipes',
                            type: AppToastType.info,
                          );
                        },
                      ),
                    ),
                  ),
                ],
                SizedBox(height: AppResponsive.value(context, 100)),
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
                    context.go('/meals');
                    break;
                  case 2:
                    context.go('/discover');
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
