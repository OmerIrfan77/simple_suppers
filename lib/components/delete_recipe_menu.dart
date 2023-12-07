import 'package:flutter/material.dart';
import 'package:simple_suppers/api_service.dart'; // Import your API service here

class DeleteMenuWidget extends StatelessWidget {
  final int recipeUserId; // Assuming you have the recipe user ID
  final Function onDeleteSuccess;

  const DeleteMenuWidget({
    Key? key,
    required this.recipeUserId,
    required this.onDeleteSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isUserAuthorized(), // Hide the menu if not authorized
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'delete') {
            _onDelete(context);
          }
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete Recipe'),
            ),
          ];
        },
      ),
    );
  }

  bool _isUserAuthorized() {
    // Fetch the logged-in user ID from your authentication system
    int loggedInUserId =
        getLoggedInUserId(); // Replace with your actual function

    // Check if the logged-in user ID matches the recipe user ID
    return recipeUserId == loggedInUserId;
  }

  Future<void> _onDelete(BuildContext context) async {
    try {
      // Make an API call to delete the recipe
      await deleteRecipe(); // Replace with your actual API call

      // Show success snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe deleted successfully'),
        ),
      );

      // Call the provided callback for additional actions on success
      onDeleteSuccess();
    } catch (error) {
      // Show error snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete recipe: $error'),
        ),
      );
    }
  }
}
