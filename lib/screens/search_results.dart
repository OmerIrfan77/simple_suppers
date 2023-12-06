import 'package:flutter/material.dart';
import 'package:simple_suppers/api_service.dart';
import 'package:simple_suppers/components/recipe_preview.dart';
import 'package:simple_suppers/models/recipe.dart';
import 'package:simple_suppers/screens/recipe_details.dart';

class SearchResults extends StatefulWidget {
  final int maxTime;
  final int maxDifficulty;
  const SearchResults(
      {super.key, required this.maxTime, required this.maxDifficulty});

  @override
  State<SearchResults> createState() => _SearhResultsState();
}

class _SearhResultsState extends State<SearchResults> {
  Future<List<Recipe>> search() async {
    return await searchRecipes(widget.maxTime, widget.maxDifficulty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: search(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data![0].title);
                if (snapshot.data!.isEmpty) {
                  return const Column(
                    children: [
                      SizedBox(height: 100),
                      Center(
                        child: Text('No results found',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                }
                return Column(
                  // children: [Text('gang shiet')],
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => RecipePreview(
                      title: snapshot.data![index].title,
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
    );
  }
}
