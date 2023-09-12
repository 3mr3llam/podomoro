import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pomodoro_timer/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/pomodoro_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PomodoroController podoController = Get.find<PomodoroController>();
  // final Future<SharedPreferences> prefss = SharedPreferences.getInstance();
  SharedPreferences? prefs;

  int? pomodoroCount;
  int? pomodoroTimer;
  int? shortBreak;
  int? longBreak;
  int? longBreakAfter;

  bool? showNotification;
  bool? isAlarmOn;
  bool? isVibrationOn;
  bool? isAwakeOn;
  bool? autoStarted;

  bool? language;

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    // initPrefs();
    // podoController.initPref();
    pomodoroCount = podoController.prefs.getInt(pomodoroTotalCountKey) ?? pomodoroPerSet;
    pomodoroTimer = podoController.prefs.getInt(pomodoroKey) ?? pomodoroTotalTime;
    shortBreak = podoController.prefs.getInt(shortBreakKey) ?? shortBreakTime;
    longBreak = podoController.prefs.getInt(longBreakKey) ?? longBreakTime;
    longBreakAfter = podoController.prefs.getInt(longBreakAfterKey) ?? longBreakAfterPomodoro;

    showNotification = podoController.prefs.getBool(showNotificationKey) ?? true;
    autoStarted = podoController.prefs.getBool(autoStartedKey) ?? true;
    isAlarmOn = podoController.prefs.getBool(alarmKey) ?? true;
    isVibrationOn = podoController.prefs.getBool(vibrationKey) ?? true;
    isAwakeOn = podoController.prefs.getBool(awakeKey) ?? false;

    language = (podoController.prefs.containsKey(langCodeKey) ? (podoController.prefs.getString(langCodeKey)! == 'en' ? false : true) : false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: GetBuilder(
              init: Get.find<PomodoroController>(),
              builder: (pomodoroController) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    _buildTimerCard("pomodoriCount".tr, pomodoroCount ?? pomodoroPerSet, 1, 120, (int value) {
                      setState(() {
                        pomodoroCount = value;
                      });
                      podoController.savePomodoPerSetCount(pomodoroTotalCountKey, value);
                    }),
                    _buildTimerCard("pomodoroTimer".tr, pomodoroTimer ?? pomodoroTotalTime, 1, 120, (int value) {
                      setState(() {
                        pomodoroTimer = value;
                      });
                      podoController.savePomodoTimer(pomodoroKey, value);
                    }),
                    _buildTimerCard("shortBreak".tr, shortBreak ?? shortBreakTime, 1, 120, (int value) {
                      setState(() {
                        shortBreak = value;
                      });
                      podoController.saveShortBreak(shortBreakKey, value);
                    }),
                    _buildTimerCard("longBreak".tr, longBreak ?? longBreakTime, 1, 120, (int value) {
                      setState(() {
                        longBreak = value;
                      });
                      podoController.saveLongBreak(longBreakKey, value);
                    }),
                    _buildTimerCard("longBreakAfter".tr, longBreakAfter ?? pomodoroPerSet, 1, 120, (int value) {
                      setState(() {
                        longBreakAfter = value;
                      });
                      podoController.saveLongBreakAfter(longBreakAfterKey, value);
                    }),
                    _buildSwitchCard("enableAutostart".tr, autoStarted!, (bool value) {
                      setState(() {
                        autoStarted = value;
                      });
                      podoController.saveAutoStarted(autoStartedKey, value);
                    }),
                    (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android)
                        ? Column(
                            children: [
                              _buildSwitchCard("showNotification".tr, showNotification!, (bool value) {
                                setState(() {
                                  showNotification = value;
                                });
                                podoController.saveShowNotification(showNotificationKey, value);
                              }),
                              _buildSwitchCard("alarmSound".tr, isAlarmOn!, (bool value) {
                                setState(() {
                                  isAlarmOn = value;
                                });
                                podoController.saveAlarm(alarmKey, value);
                              }),
                              _buildSwitchCard("vibration".tr, isVibrationOn ?? true, (bool value) {
                                setState(() {
                                  isVibrationOn = value;
                                });
                                podoController.saveVibration(vibrationKey, value);
                              }),
                              _buildSwitchCard("keepPhoneAwake".tr, isAwakeOn ?? false, (bool value) {
                                setState(() {
                                  isAwakeOn = value;
                                });
                                podoController.saveAwake(awakeKey, value);
                              }),
                            ],
                          )
                        : Container(),
                    _buildLanguageSwitchCard("language".tr, language ?? false, (bool value) {
                      setState(() {
                        language = value;
                      });
                      podoController.saveLanguage(langCodeKey, value);
                    }),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _buildTimerCard(String title, int value, int minValue, int maxValue, Function callback) {
    return Card(
      color: secondaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            NumberPicker(
              value: value,
              minValue: minValue,
              maxValue: maxValue,
              step: 1,
              itemHeight: 40,
              itemWidth: 40,
              haptics: true,
              textStyle: const TextStyle(color: Colors.white38),
              selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0),
              axis: Axis.horizontal,
              onChanged: (value) {
                callback(value);
              },
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchCard(String title, bool switchValue, Function callback) {
    return Card(
      color: secondaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            FlutterSwitch(
              width: 100.0,
              height: 40.0,
              valueFontSize: 18.0,
              toggleSize: 18.0,
              value: switchValue,
              borderRadius: 30.0,
              padding: 8.0,
              showOnOff: true,
              activeColor: Colors.blue.shade700,
              inactiveColor: Colors.blueGrey,
              activeText: "ON",
              inactiveText: "OFF",
              onToggle: (val) {
                callback(val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSwitchCard(String title, bool switchValue, Function callback) {
    // print(MyApp.localeController.intialLang);
    // print(podoController.prefs.getString(langCodeKey)!);
    // print(switchValue);
    return Card(
      color: secondaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            FlutterSwitch(
              width: 150.0,
              height: 40.0,
              valueFontSize: 18.0,
              toggleSize: 18.0,
              value: switchValue,
              borderRadius: 30.0,
              padding: 8.0,
              showOnOff: true,
              activeColor: Colors.blue.shade700,
              inactiveColor: Colors.blue.shade700,
              inactiveText: "العربية",
              activeText: "English",
              onToggle: (val) {
                callback(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
