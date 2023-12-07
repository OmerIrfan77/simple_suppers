import 'package:flutter/material.dart';
import 'package:simple_suppers/api_service.dart';

class DeleteMenuWidget extends StatelessWidget {
  final int recipeUserId;
  final AuthService auth;
  final Function onDeleteSuccess;

  const DeleteMenuWidget({
    Key? key,
    required this.recipeUserId,
    required this.auth,
    required this.onDeleteSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isUserAuthorized(auth),
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

  bool _isUserAuthorized(AuthService auth) {
    int loggedInUserId = auth.getId();

    return recipeUserId == loggedInUserId;
  }

  Future<void> _onDelete(BuildContext context) async {

    await deleteRecipe().then((value) {
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe deleted successfully'),
          ),
        );
        onDeleteSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete recipe.'),
          ),
        );
      }
    });

  }
}
