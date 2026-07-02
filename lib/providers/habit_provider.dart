import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';

const _uuid = Uuid();

class HabitProvider extends ChangeNotifier {
  final Box<Habit> _box;
  final List<Habit> _habits;

  HabitProvider({required Box<Habit> box})
      : _box = box,
        _habits = box.values.toList();

  List<Habit> get habits => List.unmodifiable(_habits);

  List<Habit> get todayHabits {
    final today = _normalize(DateTime.now());
    return _habits.where((h) {
      return h.isCompletedOn(today) ||
          _normalize(h.createdAt).isBefore(today) ||
          _normalize(h.createdAt) == today;
    }).toList();
  }

  Habit? getHabit(String id) {
    try {
      return _habits.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  void addHabit(String name, {String? description}) {
    final habit = Habit(
      id: _uuid.v4(),
      name: name,
      description: description,
    );
    _habits.add(habit);
    _box.put(habit.id, habit);
    notifyListeners();
  }

  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    _box.delete(id);
    notifyListeners();
  }

  void toggleHabit(String id, DateTime date) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final habit = _habits[index];
    final normalized = _normalize(date);

    if (habit.isCompletedOn(date)) {
      _habits[index] = habit.copyWith(
        completedDates: habit.completedDates
            .where((d) => _normalize(d) != normalized)
            .toSet(),
      );
    } else {
      _habits[index] = habit.copyWith(
        completedDates: {...habit.completedDates, normalized},
      );
    }
    _box.put(id, _habits[index]);
    notifyListeners();
  }

  static DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
