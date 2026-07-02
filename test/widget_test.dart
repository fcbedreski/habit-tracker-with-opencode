import 'package:flutter_test/flutter_test.dart';

import 'package:habit_tracker/models/habit.dart';

void main() {
  group('Habit model', () {
    test('is not completed on a date by default', () {
      final habit = Habit(id: '1', name: 'Test');
      expect(habit.isCompletedOn(DateTime.now()), false);
    });

    test('is completed on a date after toggling', () {
      final habit = Habit(
        id: '1',
        name: 'Test',
        completedDates: {DateTime.now()},
      );
      expect(habit.isCompletedOn(DateTime.now()), true);
    });

    test('streak is 0 with no completions', () {
      final habit = Habit(id: '1', name: 'Test');
      expect(habit.currentStreak, 0);
    });

    test('streak is 1 with one completion', () {
      final habit = Habit(
        id: '1',
        name: 'Test',
        completedDates: {DateTime.now()},
      );
      expect(habit.currentStreak, 1);
    });

    test('streak counts consecutive days', () {
      final today = DateTime.now();
      final habit = Habit(
        id: '1',
        name: 'Test',
        completedDates: {
          today,
          today.subtract(const Duration(days: 1)),
          today.subtract(const Duration(days: 2)),
        },
      );
      expect(habit.currentStreak, 3);
    });

    test('streak resets on gap', () {
      final today = DateTime.now();
      final habit = Habit(
        id: '1',
        name: 'Test',
        completedDates: {
          today,
          today.subtract(const Duration(days: 2)),
        },
      );
      expect(habit.currentStreak, 1);
    });
  });
}