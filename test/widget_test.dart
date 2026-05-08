import 'package:flutter_test/flutter_test.dart';
import 'package:woodfish_game/app.dart';

void main() {
  testWidgets('App renders menu screen', (WidgetTester tester) async {
    await tester.pumpWidget(const WoodfishApp());
    expect(find.text('木鱼解压'), findsOneWidget);
    expect(find.text('敲 木 鱼'), findsOneWidget);
  });
}
