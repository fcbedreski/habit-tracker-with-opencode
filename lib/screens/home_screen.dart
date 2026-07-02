import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_tile.dart';

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

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return HabitTile(
              habit: habit,
              isCompletedToday: habit.isCompletedOn(today),
              onToggle: () => provider.toggleHabit(habit.id, today),
              onDelete: () => provider.deleteHabit(habit.id),
            );
          },
        );
      },
    );
  }
}
