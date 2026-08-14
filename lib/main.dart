import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injection_container.dart' as di;
import 'presentation/bloc/product/product_bloc.dart';
import 'presentation/bloc/product/product_event.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  // Make sure Flutter is fully initialized before
  // initializing dependencies.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection.
  await di.init();

  // Start the application.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) => di.sl<ProductBloc>()..add(const GetProductsEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'ShopEasy',

        // --------------------------------------------------------
        // THEME
        // --------------------------------------------------------

        theme: ThemeData(
          useMaterial3: true,

          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.dark,
          ),

          scaffoldBackgroundColor:
              const Color(0xFFF8F7FA),

          // ------------------------------------------------------
          // APP BAR
          // ------------------------------------------------------

          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF202124),
            elevation: 0,
            centerTitle: false,

            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),

          // ------------------------------------------------------
          // ELEVATED BUTTON
          // ------------------------------------------------------

          elevatedButtonTheme:
              ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                52,
              ),

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),

              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ------------------------------------------------------
          // INPUT FIELDS
          // ------------------------------------------------------

          inputDecorationTheme:
              InputDecorationTheme(
            filled: true,

            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),

              borderSide: BorderSide.none,
            ),

            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),

              borderSide: BorderSide.none,
            ),

            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(14),

              borderSide: const BorderSide(
                color: Color(0xFF6750A4),
                width: 2,
              ),
            ),

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
          ),

          // ------------------------------------------------------
          // CARD THEME
          // ------------------------------------------------------

          cardTheme: CardThemeData(
            color: Colors.white,

            elevation: 0,

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),
          ),
        ),

        // --------------------------------------------------------
        // FIRST ROUTE
        // --------------------------------------------------------

        initialRoute: '/',

        // --------------------------------------------------------
        // NAMED ROUTES
        // --------------------------------------------------------

        onGenerateRoute:
            AppRoutes.generateRoute,
      ),
    );
  }
}