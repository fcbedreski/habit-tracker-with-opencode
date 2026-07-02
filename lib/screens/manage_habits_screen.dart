import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import 'edit_habit_screen.dart';

class ManageHabitsScreen extends StatelessWidget {
  const ManageHabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, _) {
        final habits = provider.habits;

        if (habits.isEmpty) {
          return const Center(
            child: Text('No habits yet. Create one from the Today tab.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return Dismissible(
              key: ValueKey(habit.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _confirmDelete(context, habit.name),
              onDismissed: (_) => provider.deleteHabit(habit.id),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(habit.name),
                  subtitle: habit.description != null &&
                          habit.description!.isNotEmpty
                      ? Text(
                          habit.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditHabitScreen(habit: habit),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditHabitScreen(habit: habit),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String habitName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text('Are you sure you want to delete "$habitName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
