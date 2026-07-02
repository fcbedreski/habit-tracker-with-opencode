class Habit {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final Set<DateTime> completedDates;

  Habit({
    required this.id,
    required this.name,
    this.description,
    DateTime? createdAt,
    Set<DateTime>? completedDates,
  })  : createdAt = createdAt ?? DateTime.now(),
        completedDates = completedDates ?? {};

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    Set<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  bool isCompletedOn(DateTime date) {
    final normalized = _normalizeDate(date);
    return completedDates.any((d) => _normalizeDate(d) == normalized);
  }

  int get currentStreak {
    final sorted = completedDates.map(_normalizeDate).toList()
      ..sort((a, b) => b.compareTo(a));

    if (sorted.isEmpty) return 0;

    int streak = 1;
    for (int i = 0; i < sorted.length - 1; i++) {
      final diff = sorted[i].difference(sorted[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  String toString() =>
      'Habit(id: $id, name: $name, streak: $currentStreak)';
}
