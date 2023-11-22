import 'package:flutter/material.dart';
import 'package:simple_suppers/screens/login.dart';
import 'package:simple_suppers/screens/recipe_details.dart';
import 'package:simple_suppers/components/recipe_preview.dart';
import 'package:simple_suppers/bottom_bar.dart';
// import the 'api_service.dart' file from backend folder
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Suppers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SimpleSuppers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List to hold the results from the API call
  List<dynamic> data = [];
  Future<List<dynamic>> allRecipes() async {
    return await fetchAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 240),
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: allRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: List.generate(
                        snapshot.data!.length,
                        (index) => RecipePreview(
                          title: snapshot.data![index]['title'],
                          shortDescription: snapshot.data![index]
                              ['short_description'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetails(
                                  title: snapshot.data![index]['title'],
                                  recipeId: snapshot.data![index]['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),

        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
