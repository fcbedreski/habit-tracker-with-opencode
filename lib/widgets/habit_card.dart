import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCompleted ? Colors.teal : theme.colorScheme.primary;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${habit.currentStreak} day${habit.currentStreak == 1 ? '' : 's'} streak',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
