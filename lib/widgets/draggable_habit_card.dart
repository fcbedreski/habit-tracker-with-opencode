import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'habit_card.dart';

class DraggableHabitCard extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;

  const DraggableHabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Habit>(
      data: habit,
      delay: const Duration(milliseconds: 200),
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: HabitCard(habit: habit, isCompleted: isCompleted),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: HabitCard(habit: habit, isCompleted: isCompleted),
      ),
      child: HabitCard(habit: habit, isCompleted: isCompleted),
    );
  }
}
