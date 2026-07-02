import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final bool isCompletedToday;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitTile({
    super.key,
    required this.habit,
    required this.isCompletedToday,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: isCompletedToday,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            decoration: isCompletedToday ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Streak: ${habit.currentStreak} day${habit.currentStreak == 1 ? '' : 's'}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
