import 'package:drip_store/features/authentication/login_screen.dart';
import 'package:drip_store/features/authentication/register_screen.dart';
import 'package:drip_store/features/cart/cart_screen.dart';
import 'package:drip_store/features/detail_page/detail_product_screen.dart';
import 'package:drip_store/features/home/home_screen.dart';
import 'package:drip_store/features/main_screen.dart';
import 'package:drip_store/features/profile/menu_profile/edit_account_screen.dart';
import 'package:drip_store/features/profile/menu_profile/edit_password_screen.dart';
import 'package:drip_store/features/profile/profile_screen.dart';
import 'package:drip_store/model/api/api_service.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final authProvider = AuthProvider(ApiService());

final GoRouter _appRouter = GoRouter(
  initialLocation: '/home',
  refreshListenable: authProvider,
  redirect: (context, state) {
    final auth = context.read<AuthProvider>();
    final currentLocation = state.uri.toString();

    if (!auth.isInitialized) {
      return null;
    }

    final isLoginPage = currentLocation == '/login';
    final isRegisterPage = currentLocation == '/register';

    if (auth.isLoggedIn && (isLoginPage || isRegisterPage)) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen()
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen()
    ),

    GoRoute(
      builder: (context, state) {
        final idParam = state.pathParameters['id'];
        final int productId = int.parse(idParam ?? '0');
        return DetailProductScreen(productId: productId);
      },
      path: '/product/:id',
    ),

    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen()
        ),

        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen()
        ),

        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),

          routes: [
            GoRoute(
              path: 'edit_account',
              builder: (context, state) => const EditAccountScreen()
            ),

            GoRoute(path: 'password',
            builder: (context, state) => const EditPasswordScreen()
            ),
          ]
        ),
      ],
    ),
  ],
);

GoRouter get appRouter => _appRouter;
