import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_suppers/api_service.dart' show addRecipe;
import 'package:simple_suppers/screens/recipe_details.dart';

class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({super.key});

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController difficultyController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  // TextEditingController publicController = TextEditingController();
  TextEditingController stepController = TextEditingController();
  List<String> steps = [];
  List<String> publicList = <String>['Yes', 'No'];
  String publicDropdownValue = "Yes";
  var difficultyList = [1, 2, 3];
  int difficultyDropdownValue = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Grey placeholder block
                      Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                      ),

                      // Image Preview or Add Image Icon
                      imageUrlController.text.isNotEmpty
                          ? Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Image.network(
                                  imageUrlController.text,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.fill,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showAddImageUrlDialog(context);
                                  },
                                ),
                              ],
                            )
                          : IconButton(
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: () {
                                _showAddImageUrlDialog(context);
                              },
                              iconSize: 50,
                            ),
                    ],
                  ),
                  // Title
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16.0),
                  // Short Description
                  TextFormField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(labelText: 'Short Description'),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  // Estimated Time and Difficulty
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: timeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'mins', labelText: 'Estimated Time'),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          controller: budgetController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Budget', hintText: '(e.g. cheap)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Budget and Public Option
                  const Row(
                    children: [
                      Expanded(child: Text("Difficulty")),
                      SizedBox(width: 16.0),
                      Expanded(child: Text("Public")),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<int>(
                          value: difficultyDropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 4,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 190, 143, 126)),
                          underline: Container(
                            height: 2,
                            color: Colors.brown[200],
                          ),
                          onChanged: (int? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              difficultyDropdownValue = value!;
                            });
                          },
                          items: difficultyList
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: DropdownButton<String>(
                          value: publicDropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 4,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 190, 143, 126)),
                          underline: Container(
                            height: 2,
                            color: Colors.brown[200],
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              publicDropdownValue = value!;
                            });
                          },
                          items: publicList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),
                  // Detailed Instructions
                  const Text(
                    'Instructions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  for (int i = 0; i < steps.length; i++)
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: TextEditingController(text: steps[i]),
                            decoration:
                                InputDecoration(labelText: 'Step ${i + 1}'),
                            onChanged: (value) {
                              steps[i] = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              steps.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        steps.add('');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                    ),
                    child: const Text('+ Add Step'),
                  ),
                  const SizedBox(height: 16.0),
                  // Add Recipe Button
                  ElevatedButton(
                    onPressed: () async {
                      // Implement logic to send recipe data to the database
                      int result = await addRecipe(
                          instructions: steps.join(";"),
                          difficulty:
                              int.tryParse(difficultyController.text) ?? 1,
                          time: int.tryParse(timeController.text) ?? 0,
                          budget: budgetController.text,
                          creatorId: 1,
                          title: titleController.text,
                          shortDescription: descriptionController.text,
                          isPublic: publicDropdownValue.toLowerCase() == 'yes'
                              ? 1
                              : 0,
                          rating: 5,
                          imageLink: imageUrlController.text);
                      if (mounted) {
                        if (result != 0) {
                          // if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetails(recipeId: result),
                              ));
                        } else {
                          const SnackBar(
                            content: Text('Failed to add recipe!'),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      elevation: 4,
                    ),
                    child: const Text('Add Recipe'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // Function to show the pop-up window for adding image URL
  Future<void> _showAddImageUrlDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        String newImageUrl = '';

        return AlertDialog(
          title: Text(imageUrlController.text.isEmpty
              ? 'Add Image URL'
              : 'Edit Image URL'),
          content: SizedBox(
            child: TextField(
              onChanged: (value) {
                newImageUrl = value;
              },
              decoration: const InputDecoration(hintText: 'Enter URL'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up window
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Set the image URL controller with the new value
                setState(() {
                  imageUrlController.text = newImageUrl;
                });
                Navigator.of(context).pop(); // Close the pop-up window
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
