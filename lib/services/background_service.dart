import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/controllers/pomodoro_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

late PomodoroController podoController;

Future<void> initializeService() async {
  Get.lazyPut(() => PomodoroController(), fenix: true);
  podoController = Get.find<PomodoroController>();

  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,

      // notificationChannelId: notificationId.toString(),
      // initialNotificationTitle: appName,
      // initialNotificationContent: 'Initializing',
      // foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    // print("stop service");
    podoController.cancelTimer();
    service.stopSelf();
  });

  service.on('mainBtnPressed').listen((event) {
    podoController.mainBtnPressed((Function ControllerFunction) {
      ControllerFunction();
      // print("time ${podoController.remaningTime}");

      service.invoke(
        'update',
        {
          "time": podoController.remaningTime,
        },
      );
    });
  });

  /*
  int seconds = 0;

  Timer.periodic(const Duration(seconds: 2), (timer) async {
    if (service is AndroidServiceInstance) {
      // service.setForegroundNotificationInfo(
      //   title: "App in background...",
      //   content: "Update ${DateTime.now()}",
      // );
      seconds++;
      print("seconds $seconds");
    }
    
  });*/
}
