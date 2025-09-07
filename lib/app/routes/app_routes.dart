import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth/auth_service.dart';
import '../../presentation/screens/auth/sign_in/sign_in_screen.dart';
import '../../presentation/screens/main/main_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/error_handler_screen.dart';

class AppRoutes {
  AppRoutes._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final navNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'nav');

  static final router = GoRouter(
    initialLocation: '/home',
    navigatorKey: rootNavigatorKey,
    errorBuilder: (context, state) => ErrorScreen(
      errorMessage: state.error?.message,
    ),
    redirect: (context, state) async {
      if (!await AuthService().isAuthenticated()) {
        return '/auth/sign-in';
      } else {
        return null;
      }
    },
    routes: [
      _main,
      _auth,
    ],
  );

  // Auth routes
  static final _auth = GoRoute(
    path: '/auth',
    redirect: (context, state) async {
      if (!await AuthService().isAuthenticated()) {
        return '/auth/sign-in';
      } else {
        return '/home';
      }
    },
    routes: [
      GoRoute(
        path: 'sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
    ],
  );

  // Main Shell
  static final _main = ShellRoute(
    navigatorKey: navNavigatorKey,
    builder: (BuildContext context, GoRouterState state, Widget child) {
      return MainScreen(child: child);
    },
    redirect: (context, state) async {
      if (!await AuthService().isAuthenticated()) {
        return '/auth';
      } else {
        return null;
      }
    },
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
