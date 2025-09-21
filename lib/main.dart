
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/machine.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/screens/dashboard_screen.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final router = GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
              GoRoute(
                path: '/products',
                builder: (context, state) {
                  final machine = state.extra as Machine;
                  return ProductsScreen(machine: machine);
                },
              ),
            ],
            redirect: (context, state) {
              final isLoggedIn = authProvider.isLoggedIn;
              final isLoggingIn = state.matchedLocation == '/';

              if (!isLoggedIn && !isLoggingIn) {
                return '/';
              }
              if (isLoggedIn && isLoggingIn) {
                return '/dashboard';
              }
              return null;
            },
          );

          return MaterialApp.router(
            title: 'iVend Dashboard',
            theme: _buildTheme(context),
            routerConfig: router,
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    const primaryColor = Color(0xFFF97300);
    const secondaryColor = Color(0xFFFFC107);
    final baseTheme = ThemeData.light();

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.grey[100],
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        bodyMedium: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: GoogleFonts.oswald(
          color: primaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
