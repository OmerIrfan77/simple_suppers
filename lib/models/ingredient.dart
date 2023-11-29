class Ingredient {
  final int id;
  final String name;
  final String quantity;
  final int recipeId;

  Ingredient(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.recipeId});

  static Ingredient transform(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      recipeId: json['recipe_id'],
    );
  }
}
