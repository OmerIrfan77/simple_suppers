import 'package:flutter/material.dart';
import 'package:simple_suppers/components/labels.dart';
import '../api_service.dart';

// Display detailed view of a recipe, i.e. picture, description,
// ingredients & instructions, for now.


class RecipeDetails extends StatelessWidget {
  final int recipeId;
  const RecipeDetails(
      {super.key, required String title, required this.recipeId});


  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  late List recipe; // The recipe data
  int recipeId = 1; // The recipe index to fetch

  @override
  void initState() {
    super.initState();
    // async function fetchSingleRecipe() cannot run in iniState(), so
    // this function is called instead.
    fetchRecipeDetails();
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
            // Stack text on picture
            Stack(children: [
              Image.network(
                  'https://kotivara.se/wp-content/uploads/2023/02/Pizza-scaled-1-1024x683.jpg'),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    '${recipe[recipeId - 1]['title']}',
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
                      amount: '${recipe[recipeId - 1]['time']}',
                      unit: TimeUnit.minutes))
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
                      '${recipe[recipeId - 1]['shortDescription']}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12.0),
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
            ListView.builder(
              padding: const EdgeInsets.only(left: 15.0),
              shrinkWrap: true,
              itemCount: recipe.length,
              itemBuilder: (context, index) {
                return Text('${recipe[index]['ingredients']}');
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
            ListView.builder(
              padding: const EdgeInsets.only(left: 15.0),
              shrinkWrap: true,
              itemCount: recipe.length,
              itemBuilder: (context, index) {
                return Text('${recipe[index]['instructions']}');
              },
            ),
          ],
        )),
      ]),
    );
  }
}
