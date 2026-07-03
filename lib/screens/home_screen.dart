import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/drop_zone.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Consumer<HabitProvider>(
      builder: (context, provider, _) {
        final habits = provider.habits;

        if (habits.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome,
                    size: 64, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'No habits yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Tap + to create your first habit'),
              ],
            ),
          );
        }

        final todo = habits.where((h) => !h.isCompletedOn(today)).toList();
        final done = habits.where((h) => h.isCompletedOn(today)).toList();

        final theme = Theme.of(context);

        return Column(
          children: [
            Flexible(
              flex: todo.isEmpty ? 0 : 1,
              fit: todo.isEmpty ? FlexFit.loose : FlexFit.tight,
              child: DropZone(
                title: 'To Do',
                icon: Icons.radio_button_unchecked,
                color: theme.colorScheme.primary,
                habits: todo,
                isDone: false,
                onHabitDropped: (habit) {
                  provider.toggleHabit(habit.id, today);
                },
              ),
            ),
            if (todo.isNotEmpty && done.isNotEmpty)
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.grey.shade200,
              ),
            Flexible(
              flex: done.isEmpty ? 0 : 1,
              fit: done.isEmpty ? FlexFit.loose : FlexFit.tight,
              child: DropZone(
                title: 'Done',
                icon: Icons.check_circle,
                color: Colors.teal,
                habits: done,
                isDone: true,
                onHabitDropped: (habit) {
                  provider.toggleHabit(habit.id, today);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
