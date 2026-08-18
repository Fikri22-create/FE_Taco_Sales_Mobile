import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:taco_sales_insight/main.dart';

Future<void> pumpToHome(WidgetTester tester) async {
  await tester.pumpWidget(const TacoSalesInsightApp());

  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, 'sales@taco.com');
  await tester.enterText(find.byType(TextField).last, 'demo123');
  await tester.tap(find.text('Masuk'));

  await tester.pump(const Duration(milliseconds: 900));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('App renders Home with floating dock', (tester) async {
    await pumpToHome(tester);

    expect(find.text('Fikri'), findsOneWidget);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    expect(find.text('Buat Laporan'), findsOneWidget);
  });

  testWidgets('Dock navigates to History and Profile', (tester) async {
    await pumpToHome(tester);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Riwayat Laporan'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Total Poin'), findsOneWidget);
  });

  testWidgets('Report flow: outlet -> detail -> input mode', (tester) async {
    await pumpToHome(tester);

    await tester.tap(find.text('Report'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih Outlet'), findsOneWidget);

    await tester.tap(find.text('Supermarket Mega Jaya'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Outlet'), findsOneWidget);

    await tester.ensureVisible(find.text('Mulai Laporan Baru'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mulai Laporan Baru'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih Cara Melapor'), findsOneWidget);
    expect(find.text('Laporan Suara'), findsOneWidget);
    expect(find.text('Laporan Teks'), findsOneWidget);
  });

  testWidgets('Full report submission: text -> processing -> AI confirm -> summary',
      (tester) async {
    await pumpToHome(tester);

    await tester.tap(find.text('Report'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supermarket Mega Jaya'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Mulai Laporan Baru'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mulai Laporan Baru'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laporan Teks'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField),
      'Indomie goreng promo Rp 2500 stok banyak Sedaap kari ayam naik harga',
    );
    await tester.pump();

    await tester.ensureVisible(find.text('Kirim Laporan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kirim Laporan'));
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('AI Sedang Memproses Laporan'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi Hasil AI'), findsOneWidget);

    await tester.ensureVisible(find.text('Simpan & Selesai'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan & Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('Laporan Berhasil Dikirim'), findsOneWidget);
    expect(find.text('Poin Diperoleh'), findsOneWidget);

    await tester.ensureVisible(find.text('Ke Halaman Utama'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ke Halaman Utama'));
    await tester.pumpAndSettle();
    expect(find.text('Buat Laporan'), findsOneWidget);
  });

  testWidgets('Notifications screen loads and marks all read', (tester) async {
    await pumpToHome(tester);

    await tester.tap(find.byIcon(Iconsax.notification_copy).first);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('Notifikasi'), findsNWidgets(2));

    expect(find.text('Tandai Semua Dibaca'), findsOneWidget);
    await tester.tap(find.text('Tandai Semua Dibaca'));
    await tester.pumpAndSettle();

    expect(find.text('Tandai Semua Dibaca'), findsNothing);
  });
}
