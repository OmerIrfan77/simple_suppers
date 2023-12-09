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
      expect(recipe.id, recipeId);
      expect(recipe.title, 'Pancakes');
      expect(recipe.shortDescription, 'Test: Standard pancake recipe');
    });

    test('Fetch all recipes for a user', () async {
      int userId = 1;
      List<Recipe> recipes = await fetchUserRecipes(userId);
      expect(recipes, isNotEmpty);
      for (var recipe in recipes) {
        expect(recipe.creatorId, userId);
      }
    });

    test('Fetch all public recipes', () async {
      List<Recipe> recipes = await fetchAllPublicRecipes();
      expect(recipes, isNotEmpty);
      for (var recipe in recipes) {
        expect(recipe.isPublic, 1);
      }
    });

    test('Search for recipes', () async {
      int difficutly = 1;
      int maxTime = 60;
      List<Recipe> recipes = await searchRecipes(maxTime, difficutly);
      expect(recipes, isNotEmpty);
      for (var recipe in recipes) {
        expect(recipe.difficulty, difficutly);
        expect(recipe.time, lessThanOrEqualTo(maxTime));
      }
    });
  });
}
