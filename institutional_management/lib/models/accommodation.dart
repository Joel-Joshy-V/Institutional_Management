class Accommodation {
  final int id;
  final String type;
  final String capacity;
  final double price;
  final String imageUrl;
  final bool isAvailable;

  Accommodation({
    required this.id,
    required this.type,
    required this.capacity,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'],
      type: json['type'],
      capacity: json['capacity'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['imageUrl'],
      isAvailable: json['isAvailable'],
    );
  }
} 