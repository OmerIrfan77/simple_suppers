import 'package:flutter/material.dart';
import 'package:simple_suppers/components/labels.dart';
import '../api_service.dart';

// Display detailed view of a recipe, i.e. picture, description,
// ingredients & instructions, for now.

class RecipeDetails extends StatefulWidget {
  final int recipeId;
  const RecipeDetails(
      {super.key, required String title, required this.recipeId});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  // TODO: Bring the correct recipe id from previous screen/preview
  int recipeId = 1; // The recipe index to fetch, fixed number for now
  late List recipe; // The recipe data
  late List ingredients; // The ingredients is a separete list

  @override
  void initState() {
    super.initState();
    // async functions fetchSingleRecipe() and fetchIngredients() cannot
    // run inside iniState(), so this function is called instead.
    fetchRecipeDetails();
    fetchRecipeIngredients();
  }

  Future<void> fetchRecipeDetails() async {
    try {
      var data = await fetchSingleRecipe(recipeId);
      setState(() {
        recipe = data;
      });
    } catch (e) {
      print("Could not fetch recipe");
    }
  }

  Future<void> fetchRecipeIngredients() async {
    try {
      var data = await fetchIngredients(recipeId);
      setState(() {
        ingredients = data;
      });
    } catch (e) {
      print("Could not fetch ingredients");
    }
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
      body: ListView(children: [
        (Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stack recipe name and labels on picture
            Stack(children: [
              Image.network('${recipe[0]['image_link']}'),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    '${recipe[0]['title']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const Positioned(
                bottom: 40,
                right: 10,
                child: DifficultyLabel(difficultyLevel: Difficulty.beginner),
              ),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: TimeLabel(
                      amount: '${recipe[0]['time']}', unit: TimeUnit.minutes))
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
                      '${recipe[0]['short_description']}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ),
              ],
            ),
            // Ingredients below
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 7.0),
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
            ListView.builder(
              padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
              shrinkWrap: true,
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                return Text(
                    '${ingredients[index]['quantity']} ${ingredients[index]['quantity_type']} ${ingredients[index]['name']}');
              },
            ),
            // Recipe instructions
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 7.0),
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
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('${recipe[0]['instructions']}'),
            )
          ],
        )),
      ]),
    );
  }
}
