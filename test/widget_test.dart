import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('GameZoneApp smoke test', (WidgetTester tester) async {
    // Build aplikasi GameZoneApp dan picu satu frame
    await tester.pumpWidget(const GameZoneApp() as Widget);

    // Memastikan judul utama aplikasi muncul di layar
    expect(find.text('🎮 GameZone Top Up'), findsOneWidget);

    // Memastikan teks pilihan game muncul
    expect(find.text('Pilih Game'), findsOneWidget);
  });
}

class GameZoneApp {
  const new();
}