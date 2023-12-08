import 'package:flutter/material.dart';
import 'package:simple_suppers/api_service.dart';
import 'package:simple_suppers/main.dart';

class DeleteMenuWidget extends StatelessWidget {
  final bool showMenu;
  final int recipeId;

  const DeleteMenuWidget({
    super.key,
    required this.showMenu,
    required this.recipeId,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showMenu,
      child: IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
        onPressed: () {
          _showDeleteDialog(context);
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      deleteRecipe(recipeId).then((value) {
        if (value != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Recipe deleted!'),
          ));
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(
                  title: "SimpleSuppers",
                ),
              ));
        } else {
          print("Failed to delete");
        }
      });

    }
  }
}
