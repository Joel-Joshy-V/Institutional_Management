import 'package:flutter/foundation.dart';
import '../models/food_item.dart';
import '../models/food_order.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';

class CanteenProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<FoodItem> _foodItems = [];
  Map<String, int> _cart = {};
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  CanteenProvider(this._apiService);

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  List<String> get categories {
    final categories = _foodItems.map((item) => item.category).toSet().toList();
    return ['All', ...categories];
  }

  List<FoodItem> get filteredFoodItems {
    return _foodItems.where((item) {
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = item.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get cartItemCount => _cart.values.fold(0, (sum, count) => sum + count);

  double get cartTotal {
    return _cart.entries.fold(0, (total, entry) {
      final item = _foodItems.firstWhere((i) => i.id == entry.key);
      return total + (item.price * entry.value);
    });
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void searchFoodItems(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addToCart(FoodItem item) {
    _cart[item.id] = (_cart[item.id] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _cart.remove(itemId);
    notifyListeners();
  }

  Future<void> fetchFoodItems() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Mock data for testing - in a real app this would come from the API
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay

      _foodItems = [
        FoodItem(
          id: '1',
          name: 'Chicken Burger',
          description: 'Juicy chicken burger with special sauce',
          price: 5.99,
          category: 'Fast Food',
          imageUrl:
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        ),
        FoodItem(
          id: '2',
          name: 'Veggie Pizza',
          description: 'Fresh vegetables on a crispy crust',
          price: 7.99,
          category: 'Pizza',
          imageUrl:
              'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        ),
        FoodItem(
          id: '3',
          name: 'Caesar Salad',
          description: 'Fresh romaine lettuce with Caesar dressing',
          price: 4.99,
          category: 'Salads',
          imageUrl:
              'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        ),
        FoodItem(
          id: '4',
          name: 'French Fries',
          description: 'Crispy golden fries with seasoning',
          price: 2.99,
          category: 'Sides',
          imageUrl:
              'https://images.unsplash.com/photo-1576107232684-1279f390418a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        ),
        FoodItem(
          id: '5',
          name: 'Chocolate Milkshake',
          description: 'Rich and creamy chocolate milkshake',
          price: 3.99,
          category: 'Beverages',
          imageUrl:
              'https://images.unsplash.com/photo-1563805042-7684c019e1cb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        ),
        FoodItem(
          id: '6',
          name: 'Pasta Carbonara',
          description: 'Creamy pasta with bacon bits',
          price: 8.99,
          category: 'Italian',
          imageUrl:
              'https://images.unsplash.com/photo-1612874742237-6526221588e3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch food items';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> placeOrder(String specialInstructions) async {
    try {
      _isLoading = true;
      notifyListeners();

      final orderItems =
          _cart.entries.map((entry) {
            final item = _foodItems.firstWhere((i) => i.id == entry.key);
            return OrderItem(
              foodItemId: entry.key,
              quantity: entry.value,
              price: item.price * entry.value,
            );
          }).toList();

      final request = FoodOrderRequest(
        items: orderItems,
        specialInstructions: specialInstructions,
      );

      // In a real app, this would call the API
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay

      _cart.clear();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  List<CartItem> get cartItems {
    return _cart.entries.map((entry) {
      final item = _foodItems.firstWhere((i) => i.id == entry.key);
      return CartItem(
        id: item.id,
        name: item.name,
        price: item.price,
        quantity: entry.value,
      );
    }).toList();
  }
}
