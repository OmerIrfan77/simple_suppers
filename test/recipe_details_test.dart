import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_suppers/screens/recipe_details.dart';

void main() {
  testWidgets('RecipeDetails widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetails(recipeId: 1),
      ),
    );

    // Verify that the loading indicator is displayed initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for screen to load
    await tester.pump(Duration(seconds: 2));

    // App bar title is displayed correctly
    expect(find.text('SimpleSuppers'), findsOneWidget);

    // Loading indicator is no longer visible
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify that the recipe details are displayed
    expect(find.text('Recipe not found'), findsNothing);

    // Placeholder picture is not displayed
    expect(
        find.text(
            "https://kotivara.se/wp-content/uploads/2023/02/Pizza-scaled-1-1024x683.jpg"),
        findsNothing);
  });
}
