import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl = 'http://10.0.2.2:3000/api/recipes';

Future<List> fetchAllRecipes() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

Future<List> fetchSingleRecipe(int id) async {
  final response = await http.get(Uri.parse('$apiUrl/$id'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

// Fetch all the ingredients for a specific recipe
Future<List> fetchIngredients(int recipeId) async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2:3000/api/recipe_ingredients/$recipeId'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

Future<int> addRecipe({
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
    return 0;
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
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['recipeId'];
    } else {
      // Error adding recipe
      print('Failed to add recipe. Error: ${response.reasonPhrase}');
      return 0;
    }
  } catch (error) {
    // Handle network errors
    print('Error sending POST request: $error');
  }
  return 0;
}

// Search function for searching all recipes that match a difficulty level
Future<List> searchRecipeDifficulty(int difficulty) async {
  final response =
      await http.get(Uri.parse('$apiUrl/search?difficulty=$difficulty'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

// User authentication functions //

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000/api';

  Future register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    return jsonDecode(response.body);
  }

  Future login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    return jsonDecode(response.body);
  }

  Future logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Authorization': 'Bearer yourToken'},
    );

    return jsonDecode(response.body);
  }
}
