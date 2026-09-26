import 'package:flutter_test/flutter_test.dart';

import 'package:tugas_mobile/main.dart';

void main() {
  testWidgets('Home screen shows the tourism app content', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Desa Wisata Impian'), findsOneWidget);
    expect(find.text('Halo, Tri!'), findsOneWidget);
    expect(find.text('Kategori Wisata'), findsOneWidget);
    expect(find.text('Rekomendasi Spot'), findsOneWidget);
  });
}
