import 'package:flutter/material.dart';

// Display detailed view of a recipe, i.e. picture, description,
// ingredients & instructions, for now.

class RecipeDetails extends StatelessWidget {
  const RecipeDetails({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Recipe Details',
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
              const Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  'Pizza',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: const Text(
                    'Beginner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: const Text(
                    '30 min',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ]),
            // Description in orange box
            Container(
                color: Colors.amber[900],
                padding: const EdgeInsets.all(15),
                child: const Text(
                  'Sour dough pizza is actually really easy and fun to make. This recipe covers all steps to make yout very own Napolian style Margaritha.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                )),
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
            Flexible(
              child: Column(
                // Generate 10 placeholder widgets that display as ingredients.
                children: List.generate(10, (index) {
                  return Wrap(children: [
                    Text(
                      'Ingredient $index',
                    ),
                  ]);
                }),
              ),
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
            const Text('Put the oven on 200 degrees celcius'),
          ],
        )),
      ]),
    );
  }
}
