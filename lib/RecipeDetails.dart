import 'package:flutter/material.dart';

// Display detailed view of a recipe, i.e. picture, description,
// ingredients & instructions, for now.

class RecipeDetails extends StatelessWidget {
  const RecipeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
            child: (Column(
              children: [
                // Stack text on picture
                Stack(children: [
                  const Image(
                    image: AssetImage('images/pizza.jpg'),
                  ),
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: const Align(
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
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 8,
                    mainAxisSpacing: 0,
                    padding: EdgeInsets.only(left: 15),
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: const Align(
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
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.grey[850],
            indicatorColor: Colors.orange[900],

            // TODO: Put all NavigationDestinations in a separate list instead of
            // hardcoding them here

            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
                selectedIcon: Icon(
                  Icons.home_filled,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.grey,
                ),
                label: 'Create',
                selectedIcon: Icon(Icons.add_box),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                label: 'Search',
                selectedIcon: Icon(Icons.search),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shuffle,
                  color: Colors.grey,
                ),
                label: 'Shuffle',
                selectedIcon: Icon(Icons.shuffle),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                label: 'Profile',
                selectedIcon: Icon(Icons.person),
              ),
            ],
          )),
    );
  }
}
