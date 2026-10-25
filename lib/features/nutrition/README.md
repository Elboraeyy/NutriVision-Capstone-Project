# Nutrition feature

Owns food lookup, normalized nutrition facts, portions, and nutrition
calculations.

Recommended first slice:

1. Define `FoodItem` and `NutritionFacts` entities.
2. Define a repository contract for search and details.
3. Add USDA/Open Food Facts data sources behind the repository.
4. Map external DTOs at the data boundary.
5. Add a Bloc for asynchronous search and detail loading.

Do not let AI invent nutritional values. AI may explain structured values that
this feature obtains from a trusted source.
