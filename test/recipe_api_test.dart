import 'package:flutter_test/flutter_test.dart';
import 'package:simple_suppers/api_service.dart';
import 'package:simple_suppers/models/recipe.dart';

void main() {
  group('Recipe API Tests', () {
    test('Fetch all recipes', () async {
      List<Recipe> recipes = await fetchAllRecipes();
      expect(recipes, isNotEmpty);
    });

    test('Fetch single recipe', () async {
      int recipeId = 1;
      Recipe recipe = await fetchSingleRecipe(recipeId);
      expect(recipe, isNotNull);
    });
  });
}
