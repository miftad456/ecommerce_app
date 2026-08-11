import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_app/main.dart';

void main() {
  testWidgets(
    'Ecommerce app loads successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MyApp(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('ShopEasy'),
        findsOneWidget,
      );

      expect(
        find.text('Find your products'),
        findsOneWidget,
      );

      expect(
        find.text('Products'),
        findsOneWidget,
      );
    },
  );
}