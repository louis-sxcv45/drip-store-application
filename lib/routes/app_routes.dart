import 'package:drip_store/features/authentication/login_screen.dart';
import 'package:drip_store/features/authentication/register_screen.dart';
import 'package:drip_store/features/home/home_screen.dart';
import 'package:drip_store/model/api/api_service.dart';
// import 'package:drip_store/features/main_screen.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final authProvider = AuthProvider(ApiService());

final GoRouter _appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: authProvider,
  redirect: (context, state) {
    final auth = context.read<AuthProvider>();
    final currentLocation = state.uri.toString();

    if (!auth.isInitialized) {
      return null;
    }

    final isLoginPage = currentLocation == '/login';
    final isRegisterPage = currentLocation == '/register';
    // final isHomePage = currentLocation == '/home';

    if (!auth.isLoggedIn && !(isLoginPage || isRegisterPage)) {
      return '/login';
    }

    if (auth.isLoggedIn && (isLoginPage || isRegisterPage)) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final auth = context.watch<AuthProvider>();

        if (!auth.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        Future.microtask(() {
          // ignore: use_build_context_synchronously
          context.go(auth.isLoggedIn ? '/home' : '/login');
        });

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ],
);

GoRouter get appRouter => _appRouter;
