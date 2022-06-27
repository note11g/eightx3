import 'package:hive/hive.dart';

part 'record_model.g.dart';

// todo : Hive.registerAdapter(RecordModelAdapter())
// run : flutter pub run build_runner build

@HiveType(typeId: 0)
class RecordModel extends HiveObject {
  @HiveField(0)
  final DateTime recordedTime;

  @HiveField(1)
  final String videoPath;

  @HiveField(2)
  final bool isMaster;

  RecordModel(
      {required this.recordedTime,
      required this.videoPath,
      this.isMaster = false});
}
