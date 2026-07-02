import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedHabitId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final habits = provider.habits;

    final selectedHabit = _selectedHabitId == null
        ? null
        : provider.getHabit(_selectedHabitId!);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          if (habits.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String?>(
                value: _selectedHabitId,
                decoration: const InputDecoration(
                  labelText: 'Filter by habit',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('All habits'),
                  ),
                  ...habits.map((h) => DropdownMenuItem(
                        value: h.id,
                        child: Text(h.name),
                      )),
                ],
                onChanged: (v) => setState(() => _selectedHabitId = v),
              ),
            ),
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _format,
            onFormatChanged: (format) => setState(() => _format = format),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onPageChanged: (focused) => _focusedDay = focused,
            eventLoader: (day) {
              if (_selectedHabitId != null) {
                final h = provider.getHabit(_selectedHabitId!);
                return h != null && h.isCompletedOn(day) ? [h] : [];
              }
              return habits.where((h) => h.isCompletedOn(day)).toList();
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return null;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...events.map((_) => Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: const BoxDecoration(
                            color: Colors.teal,
                            shape: BoxShape.circle,
                          ),
                        )),
                  ],
                );
              },
            ),
          ),
          const Divider(),
          Expanded(child: _buildDayDetails(habits, selectedHabit)),
        ],
      ),
    );
  }

  Widget _buildDayDetails(List<Habit> habits, Habit? selectedHabit) {
    final completed = selectedHabit != null
        ? (selectedHabit.isCompletedOn(_selectedDay) ? [selectedHabit] : [])
        : habits.where((h) => h.isCompletedOn(_selectedDay)).toList();

    final formatted = DateFormat('MMM d, yyyy').format(_selectedDay);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Completed on $formatted',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (completed.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('No habits completed on this day.',
                style: TextStyle(color: Colors.grey)),
          )
        else
          ...completed.map((h) => Card(
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.teal),
                  title: Text(h.name),
                  subtitle: Text('Streak: ${h.currentStreak} days'),
                ),
              )),
        if (selectedHabit != null) ...[
          const SizedBox(height: 24),
          Text(
            '${selectedHabit.name} streak',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _buildStreakCalendar(selectedHabit),
        ],
      ],
    );
  }

  Widget _buildStreakCalendar(Habit habit) {
    final today = DateTime.now();
    final days = List.generate(30, (i) => today.subtract(Duration(days: i)));

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: days.map((day) {
        final completed = habit.isCompletedOn(day);
        final isToday = isSameDay(day, today);
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: completed ? Colors.teal : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
            border: isToday ? Border.all(color: Colors.teal.shade700, width: 2) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            day.day.toString(),
            style: TextStyle(
              fontSize: 11,
              color: completed ? Colors.white : Colors.black54,
              fontWeight: isToday ? FontWeight.bold : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
