import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/canteen_provider.dart';

class CartSheet extends StatelessWidget {
  final _specialInstructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(16),
      child: Consumer<CanteenProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: provider.cartItems.length,
                itemBuilder: (context, index) {
                  final item = provider.cartItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\$${item.price} x ${item.quantity}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => provider.removeFromCart(item.id),
                    ),
                  );
                },
              ),
              TextField(
                controller: _specialInstructionsController,
                decoration: InputDecoration(
                  labelText: 'Special Instructions',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 16),
              Text(
                'Total: \$${provider.cartTotal.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await provider.placeOrder(
                      _specialInstructionsController.text,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order placed successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to place order')),
                    );
                  }
                },
                child: Text('Place Order'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
