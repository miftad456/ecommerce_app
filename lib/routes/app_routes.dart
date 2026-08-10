
import 'package:flutter/material.dart';

import '../domain/entities/product.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/product_detail_screen.dart';
import '../presentation/screens/product_form_screen.dart';

// ============================================================
// APP ROUTES
// ============================================================
//
// All named routes are defined here.
//
//
// '/'                → Home
// '/product-detail'  → Product details
// '/product-form'    → Add/Edit product
//
// ============================================================

class AppRoutes {
  // ==========================================================
  // ROUTE GENERATOR
  // ==========================================================

  static Route generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      // --------------------------------------------------------
      // HOME
      // --------------------------------------------------------

      case '/':
        return createRoute(
          const HomeScreen(),
        );

      // --------------------------------------------------------
      // PRODUCT DETAIL
      // --------------------------------------------------------

      case '/product-detail':
        final product =
            settings.arguments as Product;

        return createRoute(
          ProductDetailScreen(
            product: product,
          ),
        );

      // --------------------------------------------------------
      // PRODUCT FORM
      // --------------------------------------------------------

      case '/product-form':
        final product =
            settings.arguments as Product?;

        return createRoute(
          ProductFormScreen(
            product: product,
          ),
        );

      // --------------------------------------------------------
      // UNKNOWN ROUTE
      // --------------------------------------------------------

      default:
        return createRoute(
          const Scaffold(
            body: Center(
              child: Text(
                'Page not found',
              ),
            ),
          ),
        );
    }
  }

  // ==========================================================
  // PAGE TRANSITION
  // ==========================================================
  //
  // New screen slides in from the right.
  //
  // ==========================================================

  static PageRouteBuilder createRoute(
    Widget page,
  ) {
    return PageRouteBuilder(
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return page;
      },

      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        const begin = Offset(
          1.0,
          0.0,
        );

        const end = Offset.zero;

        final tween = Tween<Offset>(
          begin: begin,
          end: end,
        );

        final curvedAnimation =
            CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return SlideTransition(
          position: tween.animate(
            curvedAnimation,
          ),
          child: child,
        );
      },
    );
  }
}

