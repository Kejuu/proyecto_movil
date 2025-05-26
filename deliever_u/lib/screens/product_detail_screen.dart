import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rappi_u/providers/cart_provider.dart';
import 'package:rappi_u/utils/colors.dart';

import '../models/models.dart';
import '../providers/provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productName;
  final String imagePath;
  final double price;
  final String rating;
  final String description;

  const ProductDetailScreen({
    super.key,
    required this.productName,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.description,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;
  String? observations;
  final Map<String, bool> extras = {
    'Extra queso': false,
    'Sin cebolla': false,
    'Aderezo extra': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        backgroundColor: AppColors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'product-image-${widget.productName}',
              child: Image.asset(
                widget.imagePath,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.description),
                  const SizedBox(height: 24),
                  _buildCustomizationOptions(),
                  const SizedBox(height: 24),
                  _buildQuantitySelector(),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Observaciones (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => observations = value,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _addToCart,
                child: const Text(
                  'Agregar al carrito',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  _addToCart(); // opcional: agrega el producto al carrito
                  context.push('/add-ons'); // asegúrate que esta ruta exista
                },
                child: const Text(
                  'Pagar ahora',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildCustomizationOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personaliza tu pedido',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...extras.keys.map((extra) => _buildOptionSwitch(extra)).toList(),
      ],
    );
  }

  Widget _buildOptionSwitch(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Switch(
            value: extras[title]!,
            onChanged: (value) {
              setState(() {
                extras[title] = value;
              });
            },
            activeColor: AppColors.red,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text(
          'Cantidad:',
          style: TextStyle(fontSize: 16),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (quantity > 1) {
              setState(() => quantity--);
            }
          },
        ),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => setState(() => quantity++),
        ),
      ],
    );
  }

  void _addToCart() {
    final product = Product(
      id: widget.productName.toLowerCase().replaceAll(' ', '-'),
      name: widget.productName,
      imagePath: widget.imagePath,
      price: widget.price,
      restaurantId: 'restaurant-id', // Deberías obtener esto del restaurante actual
      restaurantName: 'Restaurante Actual', // Actualizar con nombre real
      extras: Map.from(extras)..removeWhere((key, value) => !value),
    );

    final cartItem = NewCartItem(
      product: product,
      quantity: quantity,
      observations: observations,
    );

    ref.read(newCartProvider.notifier).addItem(
      cartItem,
      'restaurant-id', // ID del restaurante actual
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.productName} agregado al carrito'),
        action: SnackBarAction(
          label: 'Ver carrito',
          onPressed: () => context.push('/cart'),
        ),
      ),
    );
  }
}