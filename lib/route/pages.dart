import 'package:eightx3/route/routes.dart';
import 'package:get/get.dart';

import '../presentation/main/main_controller.dart';
import '../presentation/main/main_page.dart';
import '../presentation/splash/splash_controller.dart';
import '../presentation/splash/splash_page.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
        name: Routes.splash,
        page: () => const SplashPage(),
        binding: BindingsBuilder(() {
          Get.put(SplashController());
        })),
    GetPage(
        name: Routes.main,
        page: () => const MainPage(),
        binding: BindingsBuilder(() {
          Get.put(MainController());
        })),
  ];
}
