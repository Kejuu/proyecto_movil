import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  // Aquí la lista completa de productos, la puedes traer de donde quieras
  final List<Map<String, dynamic>> _allProducts = [
    {'name': 'Hamburguesa Clásica', 'restaurant': 'Tarcisio', 'price': 11000.0, 'imagePath': 'assets/images/burger.jpg'},
    {'name': 'Papas Fritas', 'restaurant': 'El Kiosko', 'price': 10000.0, 'imagePath': 'assets/images/fries.jpg'},
    {'name': 'Pizza Pepperoni', 'restaurant': 'Donde Juan', 'price': 15000.0, 'imagePath': 'assets/images/pizza.jpg'},
    {'name': 'Helado', 'restaurant': 'El Kiosko', 'price': 11000.0, 'imagePath': 'assets/images/food.png'},
    {'name': 'Ensalada', 'restaurant': 'Tarcisio', 'price': 11000.0, 'imagePath': 'assets/images/food.png'},
    // Agrega más productos reales
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  double _calculatePrice(String productName) {
    const priceMap = {
      'Hamburguesa Clásica': 11000.0,
      'Papas Fritas': 10000.0,
      'Pizza Pepperoni': 15000.0,
    };
    return priceMap[productName] ?? 10000.0;
  }
  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_allProducts);
    _controller.addListener(_onSearchChanged);
  }
  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final nameLower = product['name'].toLowerCase();
        final restaurantLower = product['restaurant'].toLowerCase();
        return nameLower.contains(query) || restaurantLower.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar productos...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: _filteredProducts.isEmpty
          ? const Center(child: Text('No se encontraron productos'))
          : ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text('Restaurante: ${product['restaurant']}'),
            onTap: () {
              // Aquí puedes navegar a detalle o hacer algo
              // Ejemplo:
              context.push('/product/${product['name']}',
                  extra: product);
            },
          );
        },
      ),
    );
  }
}
