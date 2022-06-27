import 'package:eightx3/presentation/main/main_controller.dart';
import 'package:eightx3/route/routes.dart';
import 'package:eightx3/core/di/app_module.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    final appModule = await initAppModule();
    final mainController = Get.put(MainController(), permanent: true);
    await mainController.initCompleter.future;
    Get.offNamed(Routes.main);
  }
}
