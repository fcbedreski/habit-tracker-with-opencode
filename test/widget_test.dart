import 'package:flutter_test/flutter_test.dart';

import 'package:habit_tracker/app.dart';

void main() {
  testWidgets('App shows empty state', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitTrackerApp());

    expect(find.text('No habits yet'), findsOneWidget);
  });
}
