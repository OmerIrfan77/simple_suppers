import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:simple_suppers/models/ingredient.dart';
import 'package:simple_suppers/models/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

String apiUrl = Platform.isAndroid
    ? 'http://10.0.2.2:3000/api'
    : 'http://localhost:3000/api';

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

Future<List<Recipe>> fetchAllRecipesLoggedIn(int userId) async {
  final response = await http.get(Uri.parse('$apiUrl/recipes/$userId'));
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

Future<List<Recipe>> fetchAllPublicRecipes() async {
  final response = await http.get(Uri.parse('$apiUrl/recipes/public'));
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

Future<List<Recipe>> fetchUserRecipes(int userId) async {
  final response = await http.get(Uri.parse('$apiUrl/recipes/user/$userId'));
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

Future<List<Recipe>> searchRecipes(int? maxTime, int? maxDifficulty) async {
  // Build the URL with the query parameters
  final Uri uri = Uri.parse('$apiUrl/recipes/search').replace(queryParameters: {
    'time': maxTime?.toString(),
    'difficulty': maxDifficulty?.toString(),
  });

  print('Search URL: $uri');

  final response = await http.get(uri);

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

// Fetch all the ingredients for a specific recipe
Future<List<Ingredient>> fetchIngredients(int recipeId) async {
  List<Ingredient> ingredients = [];
  final response =
      await http.get(Uri.parse('$apiUrl/recipe_ingredients/$recipeId'));
  if (response.statusCode == 200) {
    for (var ingredient in json.decode(response.body)) {
      ingredients.add(Ingredient.transform(ingredient));
    }
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
  return ingredients;
}

Future<bool?> deleteRecipe(int recipeId) async {
  final response = await http.delete(Uri.parse('$apiUrl/recipe/$recipeId'));
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

Future<int?> addRecipe({
  required int recipeId,
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
    return null;
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

  final http.Response response;

  try {
    if (recipeId == 0) {
      response = await http.post(
        Uri.parse('$apiUrl/recipes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      print('Adding recipe');
    } else {
      response = await http.put(Uri.parse('$apiUrl/recipe/$recipeId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
      print('Updating recipe');
    }

    if (response.statusCode == 200) {
      // Recipe added/updated successfully
      print('Recipe added/updated successfully');
      print('Response data: ${response.body}');
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['recipeId'];
    } else {
      // Error adding recipe
      print('Failed to add/update recipe. Error: ${response.reasonPhrase}');
    }
  } catch (error) {
    // Handle network errors
    print('Error sending POST/PUT request: $error');
  }
  return null;
}

//Ingredients:
Future<Map<String, dynamic>> addIngredient(String name, String unit) async {
  final response = await http.post(
    Uri.parse('$apiUrl/ingredients'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'name': name,
      'unit': unit,
    }),
  );

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to add ingredient');
  }
}

Future<void> updateIngredient(
    String id, Map<String, dynamic> updatedIngredient) async {
  final response = await http.put(
    Uri.parse('$apiUrl/api/ingredients/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(updatedIngredient),
  );

  if (response.statusCode == 200) {
    print('Ingredient updated successfully');
  } else {
    throw Exception('Failed to update ingredient');
  }
}

Future<Map<String, dynamic>> addIngredientToRecipe(
  int ingredientId,
  int recipeId,
  int quantity,
) async {
  final response = await http.post(
    Uri.parse('$apiUrl/ingredients'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'ingredientId': ingredientId,
      'recipeId': recipeId,
      'quantity': quantity,
    }),
  );

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to add ingredient to recipe');
  }
}

// User authentication functions //

class AuthService {
  static bool _isLoggedIn = false;
  static String? _username;
  static int? _id;

  static SharedPreferences? _prefs;

  AuthService() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadLoginStatus();
  }

  void _loadLoginStatus() {
    _isLoggedIn = _prefs?.getBool('isLoggedIn') ?? false;
    _username = _prefs?.getString('username');
    _id = _prefs?.getInt('id');
  }

  void _saveLoginStatus(bool isLoggedIn, String? username, int? id) async {
    _prefs?.setBool('isLoggedIn', isLoggedIn);
    _prefs?.setString('username', username ?? '');
    _prefs?.setInt('id', id ?? 0);
  }

  Future register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    return jsonDecode(response.body);
  }

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If the response is good, meaning the password is correct,
      // store the logged in username in the AuthService class
      _isLoggedIn = true;
      _username = jsonDecode(response.body)["username"];
      _id = jsonDecode(response.body)["id"];
      _saveLoginStatus(true, _username, _id);
    } else {
      // If the response is bad, clear the stored username
      _isLoggedIn = false;
      _username = null;
      _id = null;
      _saveLoginStatus(false, null, null);
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username = null;
    _id = null;
    _saveLoginStatus(false, null, null);
  }

  bool isLoggedIn() {
    return _isLoggedIn;
  }

  String? getUsername() {
    return _username;
  }

  int? getId() {
    return _id;
  }
}
