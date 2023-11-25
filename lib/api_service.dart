import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_suppers/models/recipe.dart';

Future<List<Recipe>> fetchAllRecipes() async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/api/recipes'));
  if (response.statusCode == 200) {
    List<Recipe> recipes = [];
    for (var recipe in json.decode(response.body)) {
      recipes.add(Recipe.transform(recipe));
    }
    return recipes;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

Future<Recipe> fetchSingleRecipe(int id) async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/api/recipes/$id'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return Recipe.transform(responseData[0]);
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

// Fetch all the ingredients for a specific recipe
Future<List> fetchIngredients(int recipeId) async {
  final response = await http
      .get(Uri.parse('http://localhost:3000/api/recipe_ingredients/$recipeId'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

Future<void> addRecipe({
  required String instructions,
  required int difficulty,
  required int time,
  required String budget,
  required int creatorId,
  required String title,
  required String shortDescription,
  required int isPublic,
  required int rating,
  required String imageLink,
}) async {
  // Validate input values
  if (instructions.isEmpty ||
      difficulty < 1 ||
      difficulty > 3 ||
      time <= 0 ||
      budget.isEmpty ||
      creatorId <= 0 ||
      title.isEmpty ||
      shortDescription.isEmpty ||
      (isPublic != 0 && isPublic != 1) ||
      rating < 1 ||
      rating > 5 ||
      imageLink.isEmpty) {
    print('Invalid input values. Please check and try again.');
    return;
  }

  const String apiUrl =
      'http://localhost:3000/api/recipes'; // Replace with your actual API URL

  // Data to be sent in the request body
  final Map<String, dynamic> data = {
    'instructions': instructions,
    'difficulty': difficulty,
    'time': time,
    'budget': budget,
    'creator_id': creatorId,
    'title': title,
    'short_description': shortDescription,
    'is_public': isPublic,
    'rating': rating,
    'image_link': imageLink,
  };

  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Recipe added successfully
      print('Recipe added successfully');
      print('Response data: ${response.body}');
    } else {
      // Error adding recipe
      print('Failed to add recipe. Error: ${response.reasonPhrase}');
    }
  } catch (error) {
    // Handle network errors
    print('Error sending POST request: $error');
  }
}
