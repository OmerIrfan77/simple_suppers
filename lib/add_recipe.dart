import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'dart:io'; // Import the dart:io library to work with File

class RecipeFormPage extends StatefulWidget {
  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  List<String> ingredients = [''];
  List<String> steps = [''];
  File? image; // Variable to store the selected image file

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[900], // Dark grey color for the app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(
                context); // Navigate back to the previous page (MainPage)
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image picker
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    image = File(pickedFile.path);
                  });
                }
              },
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16.0),
            // Display the selected image
            if (image != null)
              Image.file(
                image!,
                height: 100.0,
                width: 100.0,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            buildDynamicList(
              title: 'Ingredients',
              items: ingredients,
              onAdd: () {
                setState(() {
                  ingredients.add('');
                });
              },
              onDelete: (index) {
                setState(() {
                  ingredients.removeAt(index);
                });
              },
            ),
            SizedBox(height: 16.0),
            buildDynamicList(
              title: 'Steps',
              items: steps,
              onAdd: () {
                setState(() {
                  steps.add('');
                });
              },
              onDelete: (index) {
                setState(() {
                  steps.removeAt(index);
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Add logic to send data to the remote database
                // You can use the http package to make API calls
              },
              child: Text('Save Recipe'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDynamicList({
    required String title,
    required List<String> items,
    required VoidCallback onAdd,
    required Function(int) onDelete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        for (int i = 0; i < items.length; i++)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Item ${i + 1}'),
                  onChanged: (value) {
                    items[i] = value;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  onDelete(i);
                },
              ),
            ],
          ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: onAdd,
          child: Text('+ Add $title'),
        ),
      ],
    );
  }
}
