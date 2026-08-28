import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catatan_polnes/main.dart';

void main() {
  testWidgets('Catatan POLNES smoke and UI feature test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CatatanPolnesApp());
    await tester.pumpAndSettle();

    // Verify app title & branding header
    expect(find.text('Catatan POLNES ✨'), findsOneWidget);
    expect(find.text('Politeknik Negeri Samarinda'), findsOneWidget);

    // Verify initial mock notes & tags
    expect(
      find.text('Praktikum Pemrograman Perangkat Bergerak'),
      findsOneWidget,
    );

    // Open statistics dialog
    await tester.tap(find.byIcon(Icons.bar_chart_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Statistik Catatan POLNES'), findsOneWidget);

    // Close statistics dialog
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    // Open note editor dialog
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    // Verify fields in NoteEditorDialog
    expect(find.text('Tambah Catatan Baru'), findsOneWidget);
    expect(find.text('Checklist Sub-Task:'), findsOneWidget);
    expect(find.text('Tags / Label (#Hashtag):'), findsOneWidget);
  });
}
