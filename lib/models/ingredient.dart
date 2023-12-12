class Ingredient {
  String name;
  int quantity;
  String quantityType;

  Ingredient({
    this.name = "",
    this.quantity = 0,
    this.quantityType = "",
  });

  // Getters
  String getName() => name;
  int getQuantity() => quantity;
  String getQuantityType() => quantityType;

  // Setters
  void setName(String newName) {
    name = newName;
  }

  void setQuantity(int newQuantity) {
    quantity = newQuantity;
  }

  void setQuantityType(String newQuantityType) {
    quantityType = newQuantityType;
  }

  static Ingredient transform(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: json['quantity'],
      quantityType: json['quantity_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'quantity_type': quantityType,
    };
  }
}
