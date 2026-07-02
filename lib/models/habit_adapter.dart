import 'package:hive/hive.dart';
import 'habit.dart';

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final description = reader.readBool() ? reader.readString() : null;
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final datesLen = reader.readInt();
    final completedDates = <DateTime>{};
    for (var i = 0; i < datesLen; i++) {
      completedDates.add(
        DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      );
    }
    return Habit(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
      completedDates: completedDates,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeBool(obj.description != null);
    if (obj.description != null) writer.writeString(obj.description!);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeInt(obj.completedDates.length);
    for (final d in obj.completedDates) {
      writer.writeInt(d.millisecondsSinceEpoch);
    }
  }
}
