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

/// Recipe search and interactive filtering screen matching Figma node 206:6745.
class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<RecommendationsBloc>();
    _searchController = TextEditingController(text: bloc.state.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationsBloc, RecommendationsState>(
      builder: (context, state) {
        final matches = state.filteredRecipes;
        final headerHeight = AppOverlayScaffold.contentTop(context, 140);

        return AppOverlayScaffold(
          header: DiscoverHeader(
            showBack: true,
            title: 'Find your next meal.',
            subtitle: 'A few ingredients. Plenty of possibilities.',
            savedCount: state.savedRecipes.length,
            onSavedTap: () => context.pushNamed('saved-recipes'),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppResponsive.value(context, 20),
              headerHeight + AppResponsive.value(context, 14),
              AppResponsive.value(context, 20),
              AppResponsive.value(context, 32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DiscoverSearchBar(
                  controller: _searchController,
                  hintText: 'Search by recipe or ingredient',
                  onChanged: (val) {
                    context.read<RecommendationsBloc>().add(
                      RecipeSearchChanged(val),
                    );
                  },
                ),
                SizedBox(height: AppResponsive.value(context, 16)),
                RefineRecipesPanel(
                  selectedIngredients: state.selectedIngredients,
                  onIngredientToggled: (ing) {
                    context.read<RecommendationsBloc>().add(
                      RecipeIngredientToggled(ing),
                    );
                  },
                  maxCalories: state.maxCalories,
                  onCaloriesChanged: (cal) {
                    context.read<RecommendationsBloc>().add(
                      RecipeCaloriesFilterChanged(cal),
                    );
                  },
                  minProtein: state.minProtein,
                  onProteinChanged: (prot) {
                    context.read<RecommendationsBloc>().add(
                      RecipeProteinFilterChanged(prot),
                    );
                  },
                  onReset: () {
                    _searchController.clear();
                    context.read<RecommendationsBloc>().add(
                      const RecipeFiltersReset(),
                    );
                    AppToast.show(
                      context,
                      message: 'Filters reset',
                      type: AppToastType.info,
                    );
                  },
                  onApply: () {
                    AppToast.show(
                      context,
                      message: 'Showing ${matches.length} matching recipes',
                      type: AppToastType.success,
                    );
                  },
                  matchesCount: matches.length,
                ),
                SizedBox(height: AppResponsive.value(context, 24)),
                Text(
                  '${matches.length} ${matches.length == 1 ? 'recipe matches' : 'recipes match'}',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 17),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: AppResponsive.value(context, 12)),
                if (matches.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppResponsive.value(context, 24)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFDCE1D2)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: AppResponsive.value(context, 42),
                          color: AppColors.mutedGreen,
                        ),
                        SizedBox(height: AppResponsive.value(context, 10)),
                        Text(
                          'No recipes found matching these filters',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: AppResponsive.font(context, 14),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppResponsive.value(context, 4)),
                        Text(
                          'Try relaxing calorie or protein limits or clearing selected ingredients.',
                          style: TextStyle(
                            color: AppColors.mutedGreen,
                            fontSize: AppResponsive.font(context, 12),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...matches.map(
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
                            message: recipe.isSaved
                                ? 'Removed from saved recipes'
                                : 'Saved to favorites',
                            type: AppToastType.success,
                          );
                        },
                      ),
                    ),
                  ),
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
                    context.go('/meal-plan');
                    break;
                  case 2:
                    context.go('/discover');
                    break;
                  case 3:
                    context.go('/progress');
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
