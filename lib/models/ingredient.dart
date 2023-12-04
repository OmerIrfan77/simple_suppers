class Ingredient {
  final String name;
  final int quantity;
  final String quantityType;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.quantityType,
  });

  static Ingredient transform(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: json['quantity'],
      quantityType: json['quantity_type'],
    );
  }
}
