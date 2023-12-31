import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_suppers/models/recipe.dart';
import 'package:simple_suppers/screens/login.dart';
import 'package:simple_suppers/screens/recipe_details.dart';
import 'package:simple_suppers/components/recipe_preview.dart';
import 'package:simple_suppers/bottom_bar.dart';
import 'package:simple_suppers/screens/add_recipe.dart';
import 'package:simple_suppers/screens/search_results.dart';
import 'package:simple_suppers/search_filter_bottom_sheet.dart';
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
      home: const MyHomePage(
        title: 'SimpleSuppers',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List to hold the results from the API call
  int currentIndex = 0;
  int maxTime = 1;
  int maxDifficulty = 1;
  late Future<List<Recipe>> recipesFuture;

  Future<List<Recipe>> allRecipes() async {
    if (AuthService().isLoggedIn()) {
      return await fetchAllRecipesLoggedIn(AuthService().getId()!);
    } else {
      return await fetchAllPublicRecipes();
    }
  }

  @override
  void initState() {
    super.initState();
    recipesFuture =
        fetchAllPublicRecipes(); // Initialize the Future in initState
  }

  // Method to generate a random recipeId
  int generateRandomRecipeId(List<Recipe> recipes) {
    final Random random = Random();
    return recipes.isNotEmpty ? recipes[random.nextInt(recipes.length)].id : 0;
  }

  void onBottomBarTap(int index) async {
    setState(() {
      if (index == 3) {
        // If the "Random" button is pressed the currentIndex is not updated.
        recipesFuture.then((recipes) {
          int randomRecipeId = generateRandomRecipeId(recipes);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetails(
                recipeId: randomRecipeId,
              ),
            ),
          );
        });
      } else {
        currentIndex = index;
      }
    });
    if (currentIndex == 2) {
      final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SearchFilterBottomSheet();
        },
      );

      if (result != null) {
        print('Result: $result');
        setState(() {
          maxTime = result[0];
          maxDifficulty = int.parse(result[1]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Home Screen
    Widget homeWidget = SingleChildScrollView(
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
                      title: snapshot.data![index].title,
                      difficultyLevel: snapshot.data![index].difficulty,
                      time: snapshot.data![index].time,
                      shortDescription: snapshot.data![index].shortDescription,
                      imageLink: snapshot.data![index].imageLink,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetails(
                              // title: snapshot.data![index].title,
                              recipeId: snapshot.data![index].id,
                            ),
                          ),
                        ).then((value) => setState(() {}));
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
    );

    Widget bodyWidget;
    //TODO: add correct screens to each case
    switch (currentIndex) {
      case 0:
        bodyWidget = homeWidget;
        break;
      case 1:
        bodyWidget = RecipeFormPage();
        break;
      case 2:
        bodyWidget = SearchResults(
          maxTime: maxTime,
          maxDifficulty: maxDifficulty,
        );
        break;
      case 3:
        bodyWidget = homeWidget;
        break;
      case 4:
        bodyWidget = Login(title: '');
        break;
      default:
        bodyWidget = homeWidget;
    }
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
      body: bodyWidget,
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTap: (index) => onBottomBarTap(index),
        currentIndex: currentIndex,
      ),
    );
  }
}
