import 'package:eightx3/data/model/record/record_model.dart';
import 'package:eightx3/resource/values/colors.dart';
import 'package:eightx3/route/pages.dart';
import 'package:eightx3/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(RecordModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: ColorPallets.background),
      getPages: AppPages.pages,
      initialRoute: Routes.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
