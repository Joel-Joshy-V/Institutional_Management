import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/canteen_provider.dart';
import '../../widgets/cart_sheet.dart';
import '../../widgets/category_list.dart';
import '../../widgets/food_item_card.dart';
import '../../widgets/search_bar.dart';

class CanteenPage extends StatefulWidget {
  @override
  _CanteenPageState createState() => _CanteenPageState();
}

class _CanteenPageState extends State<CanteenPage> {
  @override
  void initState() {
    super.initState();
    // Load food items when page initializes
    Future.microtask(
      () =>
          Provider.of<CanteenProvider>(context, listen: false).fetchFoodItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CanteenProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Canteen'),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.purple.shade600],
                ),
              ),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () => _showCart(context),
                  ),
                  if (provider.cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${provider.cartItemCount}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body:
              provider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : provider.filteredFoodItems.isEmpty
                  ? Center(child: Text('No food items available'))
                  : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CustomSearchBar(
                            onChanged: provider.searchFoodItems,
                            hintText: 'Search food items...',
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: CategoryList(
                          categories: provider.categories,
                          selectedCategory: provider.selectedCategory,
                          onCategorySelected: provider.selectCategory,
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final foodItem = provider.filteredFoodItems[index];
                            return FoodItemCard(
                              foodItem: foodItem,
                              onAddToCart: () => provider.addToCart(foodItem),
                            );
                          }, childCount: provider.filteredFoodItems.length),
                        ),
                      ),
                    ],
                  ),
          floatingActionButton:
              provider.cartItemCount > 0
                  ? FloatingActionButton.extended(
                    onPressed: () => _showCart(context),
                    label: Text('Checkout'),
                    icon: Icon(Icons.shopping_cart_checkout),
                  )
                  : null,
        );
      },
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CartSheet(),
    );
  }
}
