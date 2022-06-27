import 'package:eightx3/data/model/record/record_model.dart';
import 'package:hive/hive.dart';

import 'record_data_source.dart';

class RecordLocalDataSource implements RecordDataSource {
  final Box<RecordModel> _hiveBox;

  RecordLocalDataSource(this._hiveBox);

  @override
  List<RecordModel> getTodayRecords({DateTime? today}) {
    assert(today != null);
    return _hiveBox.values
        .where((record) =>
            record.recordedTime.year == today!.year &&
            record.recordedTime.month == today.month &&
            record.recordedTime.day == today.day)
        .toList();
  }

  @override
  Future<void> saveRecord(RecordModel recordModel) async {
    await _hiveBox.put(recordModel.recordedTime.toIso8601String(), recordModel);
  }
}
