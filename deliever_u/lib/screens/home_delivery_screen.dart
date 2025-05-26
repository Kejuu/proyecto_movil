import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rappi_u/screens/product_detail_screen.dart';
import 'package:rappi_u/utils/colors.dart';

import '../providers/provider.dart';

class HomeDeliveryScreen extends StatelessWidget {
  const HomeDeliveryScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Entregar a',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const Row(
            children: [
              Text(
                'Universidad de Medellín, Biblioteca',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ],
      ),
      backgroundColor: AppColors.red,
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final cart = ref.watch(newCartProvider);
            final itemCount = cart.items.fold(0, (sum, item) => sum + item.quantity);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Navegación a carrito solo si hay items
                    if (itemCount > 0) {
                      context.push('/cart');
                    }
                  },
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar hamburguesas, papas, etc...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            readOnly: true, // Aquí importante para no editar aquí
            onTap: () {
              // Navegar a pantalla de búsqueda, con texto vacío
              context.push('/search');
            },
          ),
        ),
      ),
    );
  }


  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFoodCategoriesCarousel(), // Carrusel modificado
          _buildPopularItemsSection(context), // Nueva sección de ítems populares
          _buildRestaurantsList(context),
        ],
      ),
    );
  }

  Widget _buildFoodCategoriesCarousel() {
    List<Map<String, dynamic>> foodCategories = [
      {'icon': Icons.fastfood, 'name': 'Hamburguesas'},
      {'icon': Icons.fastfood, 'name': 'Papas'},
      {'icon': Icons.local_pizza, 'name': 'Pizzas'},
      {'icon': Icons.ramen_dining, 'name': 'Asiática'},
      {'icon': Icons.kebab_dining, 'name': 'Comida Rápida'},
      {'icon': Icons.icecream, 'name': 'Postres'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: foodCategories.length,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(foodCategories[index]['icon'],
                      color: AppColors.red),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 4),
                Text(foodCategories[index]['name']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularItemsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lo más popular',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 227,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFoodItemCard(context, 'Hamburguesa Clásica', 'assets/images/burger.jpg', '4.8 ⭐'),
                _buildFoodItemCard(context, 'Papas Fritas', 'assets/images/fries.jpg', '4.5 ⭐'),
                _buildFoodItemCard(context, 'Pizza Pepperoni', 'assets/images/pizza.jpg', '4.7 ⭐'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItemCard(BuildContext context, String name, String imagePath, String rating) {
    return GestureDetector(
      onTap: () {
        context.push('/product/$name', extra: {
          'name': name,
          'imagePath': imagePath,
          'price': _calculatePrice(name),
          'rating': rating,
          'description': _getProductDescription(name),
        });
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 180, // Aumenté la altura para mejor visualización
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen con Hero animation para transición suave
                Hero(
                  tag: 'product-$name',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.fastfood, size: 40),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Chip(
                            label: Text(rating),
                            backgroundColor: Colors.green[100],
                            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            color: AppColors.red,
                            iconSize: 20,
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      // Añadí precio para mejor UX
                      Text(
                        '\$${_calculatePrice(name).toStringAsFixed(2)}',
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
      ),
    );
  }

// Función auxiliar para calcular precios (ajusta según tus necesidades)
  double _calculatePrice(String productName) {
    const priceMap = {
      'Hamburguesa Clásica': 11000.0,
      'Papas Fritas': 10000.0,
      'Pizza Pepperoni': 15000.0,
    };
    return priceMap[productName] ?? 10000.0;
  }

// Función auxiliar para descripciones
  String _getProductDescription(String productName) {
    const descriptionMap = {
      'Hamburguesa Clásica': 'Deliciosa hamburguesa con carne 100% res, queso cheddar, '
          'lechuga, tomate y nuestra salsa especial. Incluye papas fritas.',
      'Papas Fritas': 'Papas fritas crujientes con corte clásico, acompañadas de '
          'salsa a elección (kétchup, mostaza, mayonesa o salsa de la casa).',
      'Pizza Pepperoni': 'Pizza con masa artesanal, salsa de tomate natural, doble '
          'pepperoni y queso mozzarella de primera calidad.',
    };
    return descriptionMap[productName] ??
        'Producto preparado con ingredientes frescos y de la mejor calidad.';
  }

  Widget _buildRestaurantsList(BuildContext context) {
    List<Map<String, dynamic>> restaurants = [
      {
        'name': 'Tarcisio',
        'rating': '4.8 ⭐',
        'specialty': 'Hamburguesas',
        'deliveryTime': '15-25 min'
      },
      {
        'name': 'El Kiosko',
        'rating': '4.5 ⭐',
        'specialty': 'Papas y Snacks',
        'deliveryTime': '10-20 min'
      },
      {
        'name': 'Donde Juan',
        'rating': '4.7 ⭐',
        'specialty': 'Pizzas',
        'deliveryTime': '20-30 min'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Restaurantes en tu U',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: restaurants.length,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  context.push('/restaurant/${restaurants[index]['name']}', extra: {
                    'name': restaurants[index]['name'],
                    'specialty': restaurants[index]['specialty'],
                  });
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image.asset(
                          'assets/images/restaurant_${index + 1}.jpg',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150,
                            color: Colors.grey[200],
                            child: const Icon(Icons.restaurant, size: 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  restaurants[index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Chip(
                                  label: Text(restaurants[index]['rating']),
                                  backgroundColor: Colors.green[100],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurants[index]['specialty'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 4),
                                Text(restaurants[index]['deliveryTime']),
                                const Spacer(),
                                Icon(Icons.star_border, color: AppColors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          context.push('/search');
        }
        if (index == 2) {
          context.push('/orders');
        }
        if (index == 3) {
          context.push('/profile');
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Pedidos'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      selectedItemColor: AppColors.red,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    );
  }
}