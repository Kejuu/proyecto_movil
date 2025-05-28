import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rappi_u/utils/colors.dart';
import 'product_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  final String restaurantName;
  final String specialty;

  const RestaurantScreen({
    super.key,
    required this.restaurantName,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    final products = _getRestaurantProducts(restaurantName);

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
        backgroundColor: AppColors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header del restaurante
          _buildRestaurantHeader(),
          const SizedBox(height: 24),
          // Lista de productos
          ...products.map((product) => _buildProductItem(context, product)).toList(),
        ],
      ),
    );
  }

  Widget _buildRestaurantHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurantName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Chip(
          label: Text(specialty),
          backgroundColor: AppColors.red.withOpacity(0.2),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 4),
            Text('4.5 (250)'),
            SizedBox(width: 16),
            Icon(Icons.access_time),
            SizedBox(width: 4),
            Text('15-25 min'),
          ],
        ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push('/product/${product['name']}', extra: {
            'name': product['name'],
            'imagePath': product['imagePath'],
            'price': product['price'],
            'rating': product['rating'],
            'description': product['description'],
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  product['imagePath'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.fastfood),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Detalles del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getRestaurantProducts(String restaurantName) {
    return [
      {
        'name': 'Hamburguesa Clásica',
        'imagePath': 'assets/images/burger.jpg',
        'price': 11000.0,
        'rating': '4.8 ⭐',
        'description': 'Hamburguesa con queso, lechuga y tomate',
      },
      {
        'name': 'Hamburguesa Doble',
        'imagePath': 'assets/images/double_burger.png',
        'price': 15000.0,
        'rating': '4.9 ⭐',
        'description': 'Doble carne con queso y tocino',
      },
      {
        'name': 'Papas Fritas',
        'imagePath': 'assets/images/fries.jpg',
        'price': 5000.0,
        'rating': '4.5 ⭐',
        'description': 'Papas fritas crujientes con salsa',
      },
      {
        'name': 'Pizza Pepperoni',
        'imagePath': 'assets/images/pizza.jpg',
        'price': 14000.0,
        'rating': '4.7 ⭐',
        'description': 'Pizza con doble pepperoni y queso mozzarella',
      },
      {
        'name': 'Tacos al Pastor',
        'imagePath': 'assets/images/tacos.png',
        'price': 12000.0,
        'rating': '4.6 ⭐',
        'description': 'Tacos con carne al pastor, piña y cebolla',
      },
      {
        'name': 'Pollo Frito',
        'imagePath': 'assets/images/fried_chicken.png',
        'price': 13000.0,
        'rating': '4.4 ⭐',
        'description': 'Piezas de pollo empanizadas y crujientes',
      },
      {
        'name': 'Combo Familiar',
        'imagePath': 'assets/images/combo.png',
        'price': 28000.0,
        'rating': '4.9 ⭐',
        'description': 'Combo de hamburguesas, papas y bebidas para 4 personas',
      },
      {
        'name': 'Ensalada César',
        'imagePath': 'assets/images/salad.png',
        'price': 9000.0,
        'rating': '4.2 ⭐',
        'description': 'Ensalada con lechuga romana, crutones y aderezo César',
      },
      {
        'name': 'Refresco Grande',
        'imagePath': 'assets/images/refresco.png',
        'price': 3500.0,
        'rating': '4.3 ⭐',
        'description': 'Bebida gaseosa fría de 500ml',
      },
      {
        'name': 'Helado de Vainilla',
        'imagePath': 'assets/images/ice_cream.png',
        'price': 4000.0,
        'rating': '4.6 ⭐',
        'description': 'Helado cremoso de vainilla en vaso',
      },
      {
        'name': 'Sushi Variado',
        'imagePath': 'assets/images/sushi.png',
        'price': 18000.0,
        'rating': '4.7 ⭐',
        'description': 'Bandeja con rollos surtidos de sushi fresco',
      },
    ];

  }
}