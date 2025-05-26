import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ejemplo de pedidos simulados
    final List<Map<String, dynamic>> processingOrders = [
      {
        'id': '12345',
        'restaurant': 'Tarcisio',
        'items': '1 Hamburguesa Clásica, 1 Papas',
        'status': 'En camino',
        'time': 'Hace 5 min',
      },
    ];

    final List<Map<String, dynamic>> pastOrders = [
      {
        'id': '12344',
        'restaurant': 'Donde Juan',
        'items': '1 Pizza Pepperoni',
        'status': 'Entregado',
        'time': 'Ayer',
      },
      {
        'id': '12343',
        'restaurant': 'El Kiosko',
        'items': '2 Papas, 1 Gaseosa',
        'status': 'Entregado',
        'time': 'Hace 2 días',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (processingOrders.isNotEmpty)
            const Text('En proceso',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...processingOrders.map((order) => _buildOrderCard(order)),

          const SizedBox(height: 24),
          const Text('Historial',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...pastOrders.map((order) => _buildOrderCard(order)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order['restaurant'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(order['items']),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order['status'],
                    style: TextStyle(
                      color: order['status'] == 'En camino'
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.w500,
                    )),
                Text(order['time'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
