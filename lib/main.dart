import 'package:flutter/material.dart';
import 'package:simple_suppers/components/recipe_preview.dart';
import 'package:simple_suppers/screens/test_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: Text(widget.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Center(
          // TODO: Need to make a separate component for this
          // and again, put all the recipes in a separate list
          // instead of hardcoding them here
          child: ListView(children: [
            RecipePreview(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TestScreen()),
              );
            }),
          ]),
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
        ));
  }
}
