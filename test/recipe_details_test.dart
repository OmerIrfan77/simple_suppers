import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_suppers/screens/recipe_details.dart';

void main() {
  testWidgets('RecipeDetails widget test', (WidgetTester tester) async {
    // Create a test widget
    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetails(recipeId: 1),
      ),
    );

    // Verify that the app bar title is displayed correctly
    expect(find.text('SimpleSuppers'), findsOneWidget);

    // Verify that the loading indicator is displayed initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate the completion of the future that fetches the recipe
    await tester.pump(Duration(seconds: 2));

    // Verify that the loading indicator is no longer displayed
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify that the recipe details are displayed correctly
    expect(find.text('Recipe not found'), findsNothing);
  });
}
