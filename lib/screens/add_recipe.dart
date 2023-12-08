import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_suppers/api_service.dart';
import 'package:simple_suppers/screens/recipe_details.dart';
import 'package:simple_suppers/models/recipe.dart';
import 'package:simple_suppers/models/ingredient.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('RecipeFormPage');

class RecipeFormPage extends StatefulWidget {
  final int recipeId;
  bool? isEditing;
  RecipeFormPage({super.key, this.recipeId = 0, this.isEditing});

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  List<String> steps = [''];
  List<Ingredient> ingredients = [
    Ingredient(name: null, quantity: null, quantityType: null),
  ];
  List<String> publicList = <String>['Yes', 'No'];
  String publicDropdownValue = "Yes";
  var difficultyList = [1, 2, 3];
  int difficultyDropdownValue = 1;
  static const String addRecipeButton = "Add Recipe";
  static const String updateRecipeButton = "Update Recipe";

  bool loaded = false;

  Future<Recipe?> fetchRecipe() async {
    try {
      if (loaded == false) {
        return fetchSingleRecipe(widget.recipeId);
      } else {
        return null;
      }
    } catch (e) {
      _logger.info("No recipe found, initialize with empty add recipe view.");
      return null;
    }
  }

  Future<List> fetchIngredientsForRecipe() async {
    Recipe? recipe = await fetchRecipe();
    List<Ingredient> listIngredient = await fetchIngredients(widget.recipeId);
    List a = [recipe, listIngredient];
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isEditing == true
            ? AppBar(
                backgroundColor: Colors.grey[850],
                leading: const BackButton(color: Colors.white),
                title: const Text('SimpleSuppers',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              )
            : null,
        body: FutureBuilder(
            future: fetchIngredientsForRecipe(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                final recipeInfo = snapshot.data;
                loaded = true;

                if (recipeInfo != null) {
                  ingredients = recipeInfo[1];
                  imageUrlController.text = recipeInfo[0].getImageLink()!;
                  titleController.text = recipeInfo[0].getTitle();
                  descriptionController.text =
                      recipeInfo[0].getShortDescription()!;
                  timeController.text = recipeInfo[0].getTime().toString();
                  budgetController.text = recipeInfo[0].getBudget();
                  steps = recipeInfo[0].getInstructions().split(';');
                  publicDropdownValue =
                      recipeInfo[0].getIsPublic() == 1 ? "Yes" : "No";
                  difficultyDropdownValue = recipeInfo[0].getDifficulty();
                }
                if (!AuthService().isLoggedIn()) {
                  return const Center(
                    child: Text('Please login to add a recipe!'),
                  );
                }

                return Form(
                  key: _formKey,
                  child: Container(
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
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return const CircularProgressIndicator();
                                                  }
                                                },
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object error,
                                                    StackTrace? stackTrace) {
                                                  return Image.asset(
                                                      'assets/placeholder_image.jpg');
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                color: Colors.white,
                                                onPressed: () {
                                                  _showAddImageUrlDialog(
                                                      context);
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
                                  decoration: const InputDecoration(
                                      labelText: 'Title *'),
                                  maxLength: 15,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  validator: (value) {
                                    return (value == null || value.isEmpty)
                                        ? 'Can not be empty!'
                                        : null;
                                  },
                                ),
                                const SizedBox(height: 8.0),
                                // Short Description
                                TextFormField(
                                  controller: descriptionController,
                                  decoration: const InputDecoration(
                                      labelText: 'Short Description'),
                                  maxLines: null,
                                  maxLength: 45,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  validator: (value) {
                                    return (value == null || value.isEmpty)
                                        ? 'Can not be empty!'
                                        : null;
                                  },
                                ),
                                const SizedBox(height: 8.0),
                                // Estimated Time and Difficulty
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: timeController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText: 'mins',
                                            labelText: 'Estimated Time'),
                                        validator: (value) {
                                          return (value == null ||
                                                  value.isEmpty)
                                              ? 'Can not be empty!'
                                              : null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: TextFormField(
                                        controller: budgetController,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            labelText: 'Budget',
                                            hintText: '(e.g. cheap)'),
                                        validator: (value) {
                                          return (value == null ||
                                                  value.isEmpty)
                                              ? 'Can not be empty!'
                                              : null;
                                        },
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
                                            color: Color.fromARGB(
                                                255, 190, 143, 126)),
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
                                            .map<DropdownMenuItem<int>>(
                                                (int value) {
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
                                            color: Color.fromARGB(
                                                255, 190, 143, 126)),
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
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
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
                                // Ingredients
                                // Ingredients Section
                                const Text(
                                  'Ingredients',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8.0),
                                // Ingredient List
                                for (int i = 0; i < ingredients.length; i++)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text: (ingredients[i].quantity)
                                                  .toString()),
                                          decoration: const InputDecoration(
                                            labelText: 'Amount',
                                            hintText: 'e.g. 3',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            ingredients[i].quantity =
                                                int.tryParse(value);
                                          },
                                          validator: (value) {
                                            return (value == null ||
                                                    value.isEmpty)
                                                ? 'Empty!'
                                                : null;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text: ingredients[i].name),
                                          decoration: const InputDecoration(
                                              labelText: 'Name',
                                              hintText: 'e.g. egg'),
                                          onChanged: (value) {
                                            ingredients[i].name = value;
                                          },
                                          validator: (value) {
                                            return (value == null ||
                                                    value.isEmpty)
                                                ? 'Empty!'
                                                : null;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text:
                                                  ingredients[i].quantityType),
                                          decoration: const InputDecoration(
                                              labelText: 'Unit',
                                              hintText: 'e.g. dl'),
                                          onChanged: (value) {
                                            ingredients[i].quantityType = value;
                                          },
                                          validator: (value) {
                                            return (value == null ||
                                                    value.isEmpty)
                                                ? 'Empty!'
                                                : null;
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (ingredients.length == 1) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'At least one ingredient!'),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              ingredients.removeAt(i);
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      ingredients.add(
                                        Ingredient(
                                            name: null,
                                            quantity: null,
                                            quantityType: null),
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                  ),
                                  child: const Text('+ Add'),
                                ),
                                const SizedBox(height: 16.0),
                                // Detailed Instructions
                                const Text(
                                  'Instructions',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8.0),
                                for (int i = 0; i < steps.length; i++)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text: steps[i]),
                                          decoration: InputDecoration(
                                              labelText: 'Step ${i + 1}'),
                                          onChanged: (value) {
                                            steps[i] = value;
                                          },
                                          maxLength: 100,
                                          maxLengthEnforcement:
                                              MaxLengthEnforcement.enforced,
                                          validator: (value) {
                                            return (value == null ||
                                                    value.isEmpty)
                                                ? 'Can not be empty!'
                                                : null;
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (steps.length == 1) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text('At least one step!'),
                                            ));
                                          } else {
                                            setState(() {
                                              steps.removeAt(i);
                                            });
                                          }
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
                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(content: Text('Done!')),
                                      );
                                      // Implement logic to send recipe data to the database
                                      int? result = await addOrUpdate();
                                      if (mounted) {
                                        if (result != null) {
                                          if (widget.recipeId != 0) {
                                            Navigator.pop(context, result);
                                          } else {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeDetails(
                                                            recipeId: result)));
                                            _refreshData();
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Failed to add recipe!'),
                                          ));
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    elevation: 4,
                                  ),
                                  child: Text(buttonText()),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                );
              }
            }));
  }

  Future<int?> addOrUpdate() {
    return addRecipe(
        recipeId: widget.recipeId,
        instructions: steps.join(";"),
        difficulty: difficultyDropdownValue,
        time: int.tryParse(timeController.text) ?? 0,
        budget: budgetController.text,
        creatorId: 1,
        title: titleController.text,
        shortDescription: descriptionController.text,
        isPublic: publicDropdownValue.toLowerCase() == 'yes' ? 1 : 0,
        rating: 5,
        imageLink: imageUrlController.text);
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

  String buttonText() {
    return widget.recipeId == 0 ? addRecipeButton : updateRecipeButton;
  }

  void _refreshData() {
    setState(() {
      imageUrlController.text = '';
      titleController.text = '';
      descriptionController.text = '';
      timeController.text = '';
      budgetController.text = '';
      steps = [''];
      publicDropdownValue = "Yes";
      difficultyDropdownValue = 1;
      ingredients = [
        Ingredient(name: null, quantity: null, quantityType: null),
      ];
    });
  }
}
