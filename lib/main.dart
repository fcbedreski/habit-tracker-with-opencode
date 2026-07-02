import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'models/habit.dart';
import 'models/habit_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  final box = await Hive.openBox<Habit>('habits');
  runApp(HabitTrackerApp(box: box));
}
