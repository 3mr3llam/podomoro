import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/models/pomodoro_status.dart';

const pomodoroTotalTime = 25;
const shortBreakTime = 5;
const longBreakTime = 15;
const pomodoroPerSet = 4;
const longBreakAfterPomodoro = 4;

// const String btnTextStart = "START POMODORO";
// const String btnTextResumePomodoro = "RESUME POMODORO";
// const String btnTextResumeBreak = "RESUME BREAK";
// const String btnTextStartShortBreak = "TAKE SHORT BREAK";
// const String btnTextStartLongBreak = "TAKE LONG BREAK";
// const String btnTextStartNewSet = "START NEW SET";
// const String btnTextPause = "PAUSE";
// const String btnTextReset = "RESET";

Map<PomodoroStatus, String> statusDescriptions = {
  PomodoroStatus.runningPomodoro: "runningPomodoro".tr,
  PomodoroStatus.pausedPomodoro: "pausedPomodoro".tr,
  PomodoroStatus.runningShortBreak: "runningShortBreak".tr,
  PomodoroStatus.pausedShortBreak: "pausedShortBreak".tr,
  PomodoroStatus.runningLongBreak: "runningLongBreak".tr,
  PomodoroStatus.pausedLongBreak: "pausedLongBreak".tr,
  PomodoroStatus.setFinished: "setFinished".tr,
};

const Map<PomodoroStatus, MaterialColor> statusColors = {
  PomodoroStatus.runningPomodoro: Colors.green,
  PomodoroStatus.pausedPomodoro: Colors.orange,
  PomodoroStatus.runningShortBreak: Colors.red,
  PomodoroStatus.pausedShortBreak: Colors.orange,
  PomodoroStatus.runningLongBreak: Colors.blue, //Colors.red,
  PomodoroStatus.pausedLongBreak: Colors.lightBlue, //Colors.orange,
  PomodoroStatus.setFinished: Colors.orange,
};

const String appName = 'Podomoro';
const String googlePlayIdentifier = 'com.pharaohapp.podomoro';
const String appStoreIdentifier = 'com.pharaohapp.podomoro';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);
const Color splashBackgroundColor = Color(0xFF212332);
const whiteColor = Colors.white;

const int menuAnimationDuration = 400;

const String pomodoroTotalCountKey = "pomodoroTotalCountKey";
const String pomodoroKey = "pomodoroKey";
const String shortBreakKey = "shortBreakKey";
const String longBreakKey = "longBreakKey";
const String longBreakAfterKey = "longBreakAfterKey";
const String showNotificationKey = "showNotificationKey";
const String autoStartedKey = "autoStartedKey";
const String alarmKey = "alarmKey";
const String vibrationKey = "vibrationKey";
const String awakeKey = "awakeKey";
const String showOnBoardingKey = "showOnBoardingKey";
const String langCodeKey = "langCodeKey";
const String notificationName = 'podomoro_notif';
const String notificationDesc = "This nofication channel is from $notificationName";
const int notificationId = 1001;
