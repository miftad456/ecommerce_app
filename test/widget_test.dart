import 'package:ecommerce_app/core/injection_container.dart' as di;
import 'package:ecommerce_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    if (!di.sl.isRegistered<SharedPreferences>()) {
      await di.init();
    }
  });

  testWidgets(
    'Ecommerce app loads successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MyApp(),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.byType(MyApp),
        findsOneWidget,
      );
    },
  );
}