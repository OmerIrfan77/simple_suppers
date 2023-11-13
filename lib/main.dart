import 'package:flutter/material.dart';

// Http package
import 'package:http/http.dart' as http;

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
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0)),
              child: const Column(
                children: [
                  Text(
                    'Welcome to SimpleSuppers!',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'SimpleSuppers is a recipe app that allows you to search for recipes based on ingredients you have on hand. You can also create your own recipes and share them with the community!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'To get started, click the "Create" button below to create your first recipe!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
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

Future<void> fetchData() async {
  final response = await http.get(Uri.parse('https:localhost:3000/api'));
  if (response.statusCode == 200) {
    // Handle successful response
    print('API Response: ${response.body}');
  } else {
    // Handle error response
    print('API Error: ${response.statusCode}');
  }
}
