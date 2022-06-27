import 'dart:async';

import 'package:eightx3/data/model/record/record_model.dart';
import 'package:eightx3/data/source/record/record_data_source.dart';
import 'package:eightx3/data/source/record/record_local_data_source.dart';
import 'package:eightx3/data/source/record/record_repository.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AppModule extends GetxService {
  final Completer<void> _isInitializeCompleter = Completer();

  late final Box<RecordModel> _recordDataBox;

  late final RecordRepository recordRepository;

  late final RecordDataSource _recordLocalDataSource;

  @override
  void onInit() async {
    _recordDataBox = await Hive.openBox('records');

    _recordLocalDataSource = RecordLocalDataSource(_recordDataBox);
    recordRepository = RecordRepository(_recordLocalDataSource);

    _completeInitialize();
    super.onInit();
  }

  void _completeInitialize() {
    _isInitializeCompleter.complete();
  }
}

AppModule get appModule => Get.find<AppModule>();

Future<AppModule> initAppModule() async {
  final m = Get.put(AppModule(), permanent: true);
  return await m._isInitializeCompleter.future.then((_) => m);
}
