import 'package:ecommerce_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'Ecommerce app loads successfully',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        const MyApp(),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.text('ShopEasy'),
        findsOneWidget,
      );
    },
  );
}