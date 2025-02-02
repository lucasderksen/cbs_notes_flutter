import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cbs_notes_flutter/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Create and view note flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on the notes list page
      expect(find.text('Notes'), findsOneWidget);

      // Tap the FAB to create a new note
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter note title
      await tester.enterText(
          find.byType(TextField).first, 'Integration Test Note');
      await tester.pumpAndSettle();

      // Enter note content
      await tester.enterText(find.byType(TextField).last,
          'This is a test note created during integration testing');
      await tester.pumpAndSettle();

      // Save the note
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // Verify we're back on the notes list
      expect(find.text('Notes'), findsOneWidget);

      // Verify our new note appears in the list
      expect(find.text('Integration Test Note'), findsOneWidget);
      expect(
          find.text('This is a test note created during integration testing'),
          findsOneWidget);
    });
  });
}
