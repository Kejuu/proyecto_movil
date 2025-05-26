import 'package:rappi_u/screens/AddOnsScreen.dart';
import 'package:rappi_u/screens/SearchScreen.dart';
import 'package:rappi_u/screens/auth_validator_screen.dart';
import 'package:rappi_u/screens/cart_items_screen.dart';
import 'package:rappi_u/screens/cart_screen.dart';
import 'package:rappi_u/screens/home_delivery_screen.dart';
import 'package:rappi_u/screens/order_screen.dart';
import 'package:rappi_u/screens/orders_screen.dart';
import 'package:rappi_u/screens/product_detail_screen.dart';
import 'package:rappi_u/screens/profile_screen.dart';
import 'package:rappi_u/screens/restaurant_screen.dart';
import 'screens/all_stores_screen.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/store_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/auth/login',
  routes: [
    GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthValidatorScreen(),
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const HomeDeliveryScreen(),
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) => const RegisterScreen(),
          ),
        ]),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
        path: '/store',
        builder: (context, state) {
          final shopId = state.extra;
          return StoreScreen(idShop: shopId as int);
        }),
    GoRoute(
      path: '/stores',
      builder: (context, state) => const AllStoresScreen(),
    ),
    GoRoute(
      path: '/order',
      builder: (context, state) => const OrderScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/cartt',
      builder: (context, state) =>  const CartItemsScreen(), ),
GoRoute(
path: '/product/:id',
builder: (context, state) {
final args = state.extra as Map<String, dynamic>? ?? {};

return ProductDetailScreen(
productName: args['name'] ?? 'Producto',
imagePath: args['imagePath'] ?? 'assets/images/default.jpg',
price: args['price']?.toDouble() ?? 0.0,
description: args['description'] ?? 'Descripción no disponible', rating: '',
);
},
),
    GoRoute(
      path: '/restaurant/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        final extra = state.extra as Map<String, dynamic>;

        return RestaurantScreen(
          restaurantName: name,
          specialty: extra['specialty'] ?? 'Comida',
        );
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: '/add-ons',
      builder: (context, state) => const AddOnsScreen(),
    ),

  ],
);
