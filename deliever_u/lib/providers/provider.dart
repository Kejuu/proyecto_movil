import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

final   newCartProvider = StateNotifierProvider<NewCartNotifier, Cart>((ref) {
  return NewCartNotifier();
});
final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]);

  void addOrder(Order newOrder) {
    state = [...state, newOrder];
    _simulateOrderProgress(newOrder.id);
  }

  void _simulateOrderProgress(String orderId) {
    final orderIndex = state.indexWhere((o) => o.id == orderId);
    if (orderIndex == -1) return;

    // Simulación de progreso del pedido
    Future.delayed(const Duration(seconds: 5), () {
      state = [
        for (final order in state)
          if (order.id == orderId)
            order..status = OrderStatus.preparing
          else
            order
      ];
    });

    Future.delayed(const Duration(seconds: 10), () {
      state = [
        for (final order in state)
          if (order.id == orderId)
            order..status = OrderStatus.onTheWayToRestaurant
          else
            order
      ];
    });

    Future.delayed(const Duration(seconds: 15), () {
      state = [
        for (final order in state)
          if (order.id == orderId)
            order..status = OrderStatus.pickedUp
          else
            order
      ];
    });

    Future.delayed(const Duration(seconds: 20), () {
      state = [
        for (final order in state)
          if (order.id == orderId)
            order..status = OrderStatus.onTheWayToYou
          else
            order
      ];
    });

    Future.delayed(const Duration(seconds: 25), () {
      state = [
        for (final order in state)
          if (order.id == orderId)
            order..status = OrderStatus.delivered
          else
            order
      ];
    });
  }
}


class NewCartNotifier extends StateNotifier<Cart> {
  NewCartNotifier() : super(Cart());

  void addItem(NewCartItem newItem, String restaurantId) {

    // Buscar si el producto ya está en el carrito
    final existingIndex = state.items.indexWhere(
          (item) => item.product.id == newItem.product.id,
    );

    if (existingIndex >= 0) {
      // Actualizar cantidad si ya existe
      final updatedItems = List<NewCartItem>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + newItem.quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Agregar nuevo item
      state = Cart(
        items: [...state.items, newItem],
        restaurantId: restaurantId, // Mantener el restaurantId
      );
    }
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void clearCart() {
    state = Cart();
  }
}