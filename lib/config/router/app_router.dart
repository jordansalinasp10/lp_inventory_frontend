import 'package:go_router/go_router.dart';
import 'package:lp_inventory_frontend/presentation/menu/menu_screen.dart';
import 'package:lp_inventory_frontend/presentation/screens/screens.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => menuScreen(),
    ),
    GoRoute(
      path: '/inventory',
      builder: (context, state) => InventoryScreen(),
    ),

    GoRoute(
      path: '/test',
      builder: (context, state) => ProductsListScreen(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);