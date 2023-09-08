import 'package:get/get.dart';
import 'package:pomodoro_timer/controllers/locale_controller.dart';
import 'package:pomodoro_timer/controllers/menu_controller.dart';
import 'package:pomodoro_timer/controllers/pomodoro_controller.dart';

class Dependencies extends Bindings {
  Dependencies();

  @override
  void dependencies() {
    Get.lazyPut(() => PomodoroController(), fenix: true);
    Get.lazyPut(() => XMenuController(), fenix: true);
    Get.lazyPut(() => LocaleController(), fenix: true);
  }
}

Future init() async {
  Get.lazyPut(() => LocaleController());
}
