import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

            //Test code creating a button that fetches data from API and then adds the list of recipes to the page
            Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        data = [];
                      });
                      addRecipe(
                        instructions: 'Test instructions again',
                        difficulty: 2,
                        time: 30,
                        budget: 'Low',
                        creatorId: 1,
                        title: 'Test title',
                        shortDescription: 'Short description',
                        isPublic: 1,
                        rating: 4,
                        imageLink: 'https://image.jpg',
                      );
                      try {
                        final fetchedData = await fetchAllRecipes();
                        setState(() {
                          data = fetchedData;
                          for (var element in data) {
                            if (kDebugMode) {
                              print(element['title']);
                            }
                          }
                        });
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    child: const Text("Fetch"),
                  ),
                  // Display a Text widget for each element in the data list
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Text(
                          '${data[index]['title']}\n${data[index]['instructions']}\n');
                    },
                  )
                ]))
          ]),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar());
  }
}
