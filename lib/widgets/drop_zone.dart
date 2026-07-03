import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'draggable_habit_card.dart';

class DropZone extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Habit> habits;
  final bool isDone;
  final void Function(Habit habit) onHabitDropped;

  const DropZone({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.habits,
    required this.isDone,
    required this.onHabitDropped,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<Habit>(
      onAcceptWithDetails: (details) => onHabitDropped(details.data),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            color: isHovering ? color.withAlpha(25) : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              if (habits.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      return DraggableHabitCard(
                        habit: habits[index],
                        isCompleted: isDone,
                      );
                    },
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    isHovering ? 'Release to drop' : 'Drag habits here',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${habits.length}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
