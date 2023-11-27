import 'dart:convert';
import 'package:http/http.dart' as http;

const apiUrl = 'http://localhost:3000/api';

Future<List> fetchAllRecipes() async {
  final response = await http.get(Uri.parse('$apiUrl/recipes'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

Future<List> fetchSingleRecipe(int id) async {
  final response = await http.get(Uri.parse('$apiUrl/recipe/$id'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

Future<List<Map<String, dynamic>>> searchRecipes(
    {int? maxTime, int? maxDifficulty}) async {
  // Build the URL with the query parameters
  final Uri uri = Uri.parse('$apiUrl/recipes/search').replace(queryParameters: {
    'time': maxTime?.toString(),
    'difficulty': maxDifficulty?.toString(),
  });

  print('Search URL: $uri');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    // Convert the response data to a List<Map<String, dynamic>>
    return List<Map<String, dynamic>>.from(responseData);
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

// Fetch all the ingredients for a specific recipe
Future<List> fetchIngredients(int recipeId) async {
  final response =
      await http.get(Uri.parse('$apiUrl/recipe_ingredients/$recipeId'));
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
      Uri.parse('$apiUrl/recipes'),
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
