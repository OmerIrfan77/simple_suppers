import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> fetchAllRecipes() async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/api/recipes'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}

Future<List> fetchSingleRecipe(int id) async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/api/recipes/$id'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('API Error: ${response.statusCode}');
  }
}
