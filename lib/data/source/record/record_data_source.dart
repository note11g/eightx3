import 'package:eightx3/data/model/record/record_model.dart';

abstract class RecordDataSource {
  Future<void> saveRecord(RecordModel recordModel);

  List<RecordModel> getTodayRecords({DateTime today});
}
