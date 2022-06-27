import '../../model/record/record_model.dart';
import 'record_data_source.dart';

class RecordRepository implements RecordDataSource {
  final RecordDataSource _localDataSource;

  RecordRepository(this._localDataSource);

  @override
  List<RecordModel> getTodayRecords({DateTime? today}) {
    today ??= DateTime.now();
    return _localDataSource.getTodayRecords(today: today);
  }

  @override
  Future<void> saveRecord(RecordModel recordModel) {
    return _localDataSource.saveRecord(recordModel);
  }
}
