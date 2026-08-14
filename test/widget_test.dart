import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:taco_sales_insight/main.dart';

void main() {
  testWidgets('App renders Home with floating dock', (tester) async {
    await tester.pumpWidget(const TacoSalesInsightApp());
    await tester.pumpAndSettle();

    // Greeting + user name from mock data
    expect(find.text('Fikri'), findsOneWidget);

    // Floating navigation dock with all 4 tabs
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Quick action to create a report
    expect(find.text('Buat Laporan'), findsOneWidget);
  });

  testWidgets('Dock navigates to History and Profile', (tester) async {
    await tester.pumpWidget(const TacoSalesInsightApp());
    await tester.pumpAndSettle();

    // History tab
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Riwayat Laporan'), findsOneWidget);

    // Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Total Poin'), findsOneWidget);
  });

  testWidgets('Report flow: outlet -> detail -> input mode', (tester) async {
    await tester.pumpWidget(const TacoSalesInsightApp());
    await tester.pumpAndSettle();

    // Report tab opens outlet selection
    await tester.tap(find.text('Report'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih Outlet'), findsOneWidget);

    // Select an outlet
    await tester.tap(find.text('Supermarket Mega Jaya'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Outlet'), findsOneWidget);

    // Start a new report (button at bottom of a scroll view)
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
    await tester.pumpWidget(const TacoSalesInsightApp());
    await tester.pumpAndSettle();

    // Navigate to text input
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

    // Fill the report (>= 5 words required)
    await tester.enterText(
      find.byType(TextFormField),
      'Indomie goreng promo Rp 2500 stok banyak Sedaap kari ayam naik harga',
    );
    await tester.pump();

    // Submit -> processing screen (1s simulated delay)
    await tester.ensureVisible(find.text('Kirim Laporan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kirim Laporan'));
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('AI Sedang Memproses Laporan'), findsOneWidget);

    // Processing completes after ~2.6s -> AI confirmation
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi Hasil AI'), findsOneWidget);

    // Save -> summary screen
    await tester.ensureVisible(find.text('Simpan & Selesai'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan & Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('Laporan Berhasil Dikirim'), findsOneWidget);
    expect(find.text('Poin Diperoleh'), findsOneWidget);

    // Back to home
    await tester.ensureVisible(find.text('Ke Halaman Utama'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ke Halaman Utama'));
    await tester.pumpAndSettle();
    expect(find.text('Buat Laporan'), findsOneWidget);
  });

  testWidgets('Notifications screen loads and marks all read', (tester) async {
    await tester.pumpWidget(const TacoSalesInsightApp());
    await tester.pumpAndSettle();

    // Open notifications via the bell icon in the home header
    // (the bell is the first notification_copy icon in the tree;
    //  the intel "Quick Report" row also uses notification_copy further down)
    await tester.tap(find.byIcon(Iconsax.notification_copy).first);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    // AppBar title + section header both say "Notifikasi"
    expect(find.text('Notifikasi'), findsNWidgets(2));

    // Mark all read action exists when there are unread notifications
    expect(find.text('Tandai Semua Dibaca'), findsOneWidget);
    await tester.tap(find.text('Tandai Semua Dibaca'));
    await tester.pumpAndSettle();

    // Action disappears once everything is read
    expect(find.text('Tandai Semua Dibaca'), findsNothing);
  });
}