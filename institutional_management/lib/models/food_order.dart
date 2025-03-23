class OrderItem {
  final String foodItemId;
  final int quantity;
  final double price;

  OrderItem({
    required this.foodItemId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'foodItemId': foodItemId,
    'quantity': quantity,
    'price': price,
  };
}

class FoodOrderRequest {
  final List<OrderItem> items;
  final String specialInstructions;

  FoodOrderRequest({
    required this.items,
    required this.specialInstructions,
  });

  Map<String, dynamic> toJson() => {
    'items': items.map((item) => item.toJson()).toList(),
    'specialInstructions': specialInstructions,
  };
}

class FoodOrder {
  final String id;
  final List<OrderItem> items;
  final String status;

  FoodOrder({
    required this.id,
    required this.items,
    required this.status,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    return FoodOrder(
      id: json['id'],
      items: (json['items'] as List).map((item) => OrderItem(
        foodItemId: item['foodItemId'],
        quantity: item['quantity'],
        price: item['price'],
      )).toList(),
      status: json['status'],
    );
  }
} 