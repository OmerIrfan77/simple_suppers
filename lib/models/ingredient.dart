class Ingredient {
  String? _name;
  int? _quantity;
  String? _quantityType;

  Ingredient({
    required String? name,
    required int? quantity,
    required String? quantityType,
  })  : _name = name,
        _quantity = quantity,
        _quantityType = quantityType;

  // Getter methods
  String? get name => _name;
  int? get quantity => _quantity;
  String? get quantityType => _quantityType;

  // Setter methods
  set name(String? name) {
    _name = name;
  }

  set quantity(int? quantity) {
    _quantity = quantity;
  }

  set quantityType(String? quantityType) {
    _quantityType = quantityType;
  }

  // Factory method to transform JSON to Ingredient
  factory Ingredient.transform(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: json['quantity'],
      quantityType: json['quantity_type'],
    );
  }
}
