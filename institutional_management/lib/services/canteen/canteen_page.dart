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
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Canteen',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1559305616-3f99cd43e353?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart, color: Colors.white),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (provider.isLoading)
                SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.filteredFoodItems.isEmpty)
                SliverFillRemaining(
                  child: Center(child: Text('No food items available')),
                )
              else ...[
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
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    140,
                  ), // Increased to 140px to ensure no overflow
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          0.8, // Adjusted from 0.75 to 0.8 for better fit
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final foodItem = provider.filteredFoodItems[index];
                      return FoodItemCard(
                        foodItem: foodItem,
                        onAddToCart: () => provider.addToCart(foodItem),
                      );
                    }, childCount: provider.filteredFoodItems.length),
                  ),
                ),
              ],
            ],
          ),
          floatingActionButton:
              provider.cartItemCount > 0
                  ? FloatingActionButton.extended(
                    onPressed: () => _showCart(context),
                    label: Text('Checkout'),
                    icon: Icon(Icons.shopping_cart_checkout),
                    backgroundColor: Colors.blue.shade700,
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
