import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';
import '../providers/provider.dart';

class AddOnsScreen extends ConsumerStatefulWidget {
  const AddOnsScreen({super.key});

  @override
  ConsumerState<AddOnsScreen> createState() => _AddOnsScreenState();
}

class _AddOnsScreenState extends ConsumerState<AddOnsScreen> {
  final List<Map<String, dynamic>> addOns = [
    {
      'name': 'Papas Fritas',
      'price': 5000.00,
      'imagePath': 'assets/images/fries.jpg',
      'quantity': 0,
    },
    {
      'name': 'Refresco',
      'price': 3000.00,
      'imagePath': 'assets/images/refresco.png',
      'quantity': 0,
    },
    {
      'name': 'Postre',
      'price': 4000.00,
      'imagePath': 'assets/images/postre.png',
      'quantity': 0,
    },
  ];

  void _addAddOnsToCart(List<Map<String, dynamic>> selectedAddOns) {
    for (var item in selectedAddOns) {
      final product = Product(
        id: item['name'].toLowerCase().replaceAll(' ', '-'),
        name: item['name'],
        imagePath: item['imagePath'],
        price: item['price'],
        restaurantId: 'restaurant-id',
        restaurantName: 'Restaurante Actual'
      );

      final cartItem = NewCartItem(
        product: product,
        quantity: item['quantity'],
        observations: null,
      );

      ref.read(newCartProvider.notifier).addItem(
        cartItem,
        'restaurant-id', // ID del restaurante actual
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Acompañamientos agregados al carrito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acompaña tu pedido'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: addOns.length,
        itemBuilder: (context, index) {
          final item = addOns[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Image.asset(
                item['imagePath'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(item['name']),
              subtitle: Text('\$${item['price'].toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        if (item['quantity'] > 0) item['quantity']--;
                      });
                    },
                  ),
                  Text(
                    '${item['quantity']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        item['quantity']++;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            final selected = addOns.where((item) => item['quantity'] > 0).toList();

            _addAddOnsToCart(selected);
            context.push('/cart');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Continuar al pago',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
