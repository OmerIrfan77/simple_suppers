import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_suppers/models/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = 'http://localhost:3000/api';

Future<List<Recipe>> fetchAllRecipes() async {
  final response = await http.get(Uri.parse('$apiUrl/recipes'));
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
  final response = await http.get(Uri.parse('$apiUrl/recipe/$id'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return Recipe.transform(responseData[0]);
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

// User authentication functions //

class AuthService {
  Future register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    return jsonDecode(response.body);
  }

  Future login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData.containsKey('token')) {
      // Store the token in shared preferences
      await _saveToken(responseData['token']);
    }

    return responseData;
  }

  Future logout() async {
    await _removeToken();

    final response = await http.post(
      Uri.parse('$apiUrl/logout'),
      headers: {'Authorization': 'Bearer yourToken'},
    );

    return jsonDecode(response.body);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Private method to remove the token from shared preferences
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
