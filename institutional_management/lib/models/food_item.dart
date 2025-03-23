class FoodItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final String description;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['imageUrl'],
      category: json['category'],
      description: json['description'],
    );
  }
}
