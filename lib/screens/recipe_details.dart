import 'package:flutter/material.dart';
import 'package:simple_suppers/components/labels.dart';
import 'package:simple_suppers/models/ingredient.dart';
import 'package:simple_suppers/models/recipe.dart';
import 'package:simple_suppers/screens/add_recipe.dart';
import '../api_service.dart';

// Display detailed view of a recipe, i.e. picture, description,
// ingredients & instructions, for now.

class RecipeDetails extends StatefulWidget {
  final int recipeId;
  const RecipeDetails({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  Future<Recipe> singleRecipe() async {
    return await fetchSingleRecipe(widget.recipeId);
  }

  Future<List<Ingredient>> ingredients() async {
    return await fetchIngredients(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        leading: const BackButton(color: Colors.white),
        title: const Text('SimpleSuppers',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder(
        future: singleRecipe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still running, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurred, display an error message
            return Text('Error: ${snapshot.error}');
          } else {
            final recipe = snapshot.data;

            if (recipe == null) {
              return const Center(child: Text('Recipe not found'));
            }

            return ListView(children: [
              (Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Stack text on picture
                  Stack(children: [
                    Image.network(recipe.imageLink ??
                        'https://kotivara.se/wp-content/uploads/2023/02/Pizza-scaled-1-1024x683.jpg'),
                    Positioned(
                        bottom: 10,
                        left: 10,
                        child: Row(children: [
                          Text(
                            recipe.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.recipeId != //change to creatorId later
                              0) // Conditionally show the Icon child
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeFormPage(
                                          recipeId: widget.recipeId),
                                    ));
                              },
                            ),
                        ])),
                    const Positioned(
                      bottom: 40,
                      right: 10,
                      child:
                          DifficultyLabel(difficultyLevel: Difficulty.beginner),
                    ),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: TimeLabel(
                            amount: recipe.time, unit: TimeUnit.minutes))
                  ]),
                  // Description in orange box
                  // Using Row() + Expanded() fill the horizontal space with orange container
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.amber[900],
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            '${recipe.shortDescription}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Ingredients below
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<List<Ingredient>>(
                    future: ingredients(),
                    builder: (context, ingredientSnapshot) {
                      if (ingredientSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        // If the Future is still running, show a loading indicator
                        return const Center(child: CircularProgressIndicator());
                      } else if (ingredientSnapshot.hasError) {
                        // If an error occurred, display an error message
                        return Text('Error: ${ingredientSnapshot.error}');
                      } else {
                        final ingredientList = ingredientSnapshot.data;

                        if (ingredientList!.isEmpty) {
                          return const Center(
                              child: Text('Ingredients not found'));
                        }

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: ingredientList.length,
                            itemBuilder: (context, index) {
                              final ingredient = ingredientList[index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Container(
                                    child: Text(
                                        '${ingredient.quantity} ${ingredient.quantityType} ${ingredient.name}')),
                              );
                            });
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Step-by-step instructions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0;
                            i < recipe.instructions.split(';').length;
                            i++)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${i + 1}. ${recipe.instructions.split(';')[i]}'),
                          ),
                      ],
                    ),
                  ),
                ],
              )),
            ]);
          }
        },
      ),
    );
  }
}
