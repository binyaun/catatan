import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catatan_polnes/main.dart';

void main() {
  testWidgets('Catatan POLNES smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CatatanPolnesApp());
    await tester.pumpAndSettle();

    // Verify that the app bar title and initial notes are displayed.
    expect(find.text('Catatan POLNES'), findsOneWidget);
    expect(find.text('Politeknik Negeri Samarinda'), findsOneWidget);
    expect(
      find.text('Praktikum Pemrograman Perangkat Bergerak'),
      findsOneWidget,
    );

    // Tap the 'Tambah Catatan' FloatingActionButton and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the dialog is displayed.
    expect(find.text('Tambah Catatan Baru'), findsOneWidget);
    expect(find.text('Judul Catatan'), findsOneWidget);
  });
}
