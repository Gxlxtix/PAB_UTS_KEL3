import 'package:flutter_test/flutter_test.dart';
import 'package:uts/main.dart'; // Pastikan 'uts' ini sesuai dengan nama project Flutter kamu

void main() {
  testWidgets('LOSTIFY menampilkan halaman utama', (WidgetTester tester) async {
    await tester.pumpWidget(const LostifyApp());

    expect(find.text('LOSTIFY ITPLN'), findsOneWidget);
    expect(find.text('Halo, Mahasiswa ITPLN!'), findsOneWidget);
    expect(find.text('Laporkan Barang'), findsOneWidget); 
    // Baris terakhir ini akan error kalau teks di main.dart belum kita revisi jadi 'Laporkan Barang'
  });
}