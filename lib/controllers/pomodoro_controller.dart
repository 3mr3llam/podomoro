import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/models/pomodoro_status.dart';
import 'package:pomodoro_timer/notification_service.dart';
import 'package:pomodoro_timer/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class PomodoroController extends GetxController {
  BuildContext? context;
  final _streamController = StreamController<int>.broadcast();
  Stream<int> get stream => _streamController.stream;

  // AudioCache audioCache = AudioCache(prefix: "assets/sounds/");
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer silenceAudioPlayer = AudioPlayer();

  int remaningTime = 0;
  String mainBtnText = "";
  PomodoroStatus _status = PomodoroStatus.pausedPomodoro;
  PomodoroStatus get status => _status;
  Timer? timer;
  int pomodoroNum = 0;
  int pomodoroTotalCount = pomodoroPerSet;
  int setNum = 0;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  late NotifyHelper notifyHelper;

  int? pomodoroTimer;
  int? shortBreak;
  int? longBreak;
  int? longBreakAfter;

  bool? isAlarmOn;
  bool? isVibrationOn;
  bool? isAwakeOn;
  bool? autoStartBreak = true;
  bool? showNotification = true;

  bool isStarted = false;
  String? language;

  @override
  void onInit() {
    super.onInit();

    notifyHelper = NotifyHelper(context);
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();

    initPref();
    loadAudio();
    update();
  }

  @override
  void onClose() {
    // cancelTimer();
    audioPlayer.dispose();
    super.onClose();
  }

  void initPref() async {
    prefs = await _prefs;

    pomodoroTotalCount = (prefs.getInt(pomodoroTotalCountKey) ?? pomodoroPerSet);
    pomodoroTimer = (prefs.getInt(pomodoroKey) ?? pomodoroTotalTime) * 60;
    remaningTime = pomodoroTimer!;
    shortBreak = (prefs.getInt(shortBreakKey) ?? shortBreakTime) * 60;
    longBreak = (prefs.getInt(longBreakKey) ?? longBreakTime) * 60;
    longBreakAfter = (prefs.getInt(longBreakAfterKey) ?? longBreakAfterPomodoro);

    isAlarmOn = prefs.getBool(alarmKey) ?? true;
    isVibrationOn = prefs.getBool(vibrationKey) ?? true;
    isAwakeOn = prefs.getBool(awakeKey) ?? false;
    autoStartBreak = prefs.getBool(autoStartedKey) ?? true;
    showNotification = prefs.getBool(showNotificationKey) ?? true;
    language = prefs.containsKey(langCodeKey) ? prefs.getString(langCodeKey) : 'en';
    // print('lang ${Get.locale}');
    mainBtnText = language == 'ar' ? 'بدأ المؤقت' : 'START POMODORO'; //"btnTextStart".tr;

    update();
  }

  getPomodoroPercentage() {
    int totalTime;
    switch (status) {
      case PomodoroStatus.runningPomodoro:
        totalTime = (pomodoroTimer ?? pomodoroTotalTime);
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = (pomodoroTimer ?? pomodoroTotalTime);
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = (shortBreak ?? shortBreakTime);
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = (shortBreak ?? shortBreakTime);
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = (longBreak ?? longBreakTime);
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = (longBreak ?? longBreakTime);
        break;
      case PomodoroStatus.setFinished:
        totalTime = (pomodoroTimer ?? pomodoroTotalTime);
        break;
    }

    double percentage = (totalTime - remaningTime) / totalTime;

    return percentage;
  }

  mainBtnPressed(Function? serviceCallback) {
    switch (status) {
      case PomodoroStatus.pausedPomodoro:
        // if (serviceCallback != null) {
        //   print("start service");
        //   serviceCallback(startPomodoroCountdown());
        // } else {
        startPomodoroCountdown();
        // }
        break;
      case PomodoroStatus.runningPomodoro:
        pausePomdoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        pauseShortBreak();
        break;
      case PomodoroStatus.pausedShortBreak:
        startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        pauseLongBreak();
        break;
      case PomodoroStatus.pausedLongBreak:
        startLongBreak();
        break;
      case PomodoroStatus.setFinished:
        setNum++;
        startPomodoroCountdown();
        break;
    }
  }

  startPomodoroCountdown() {
    _status = PomodoroStatus.runningPomodoro;
    // remaningTime = (pomodoroTimer ?? pomodoroTotalTime);
    isStarted = true;

    if (isAwakeOn!) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }

    cancelTimer();
    playSilenceSound();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remaningTime > 0) {
        remaningTime--;
        _streamController.sink.add(remaningTime);

        if (showNotification! &&
            (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.linux ||
                defaultTargetPlatform == TargetPlatform.macOS)) {
          notifyHelper.displayNotification(title: appName, body: formatTime(remaningTime));
        }

        mainBtnText = language == 'ar' ? 'توقف' : 'PAUSE'; //"btnTextPause".tr;
        Get.updateLocale(Get.locale!);
        update();
      } else {
        stopSilenceSound();
        playSound();
        vibrate();
        pomodoroNum++;
        cancelTimer();

        if (pomodoroTotalCount == pomodoroNum) {
          notifyHelper.cancelNotification();
        }

        if (pomodoroNum % longBreakAfter! == 0 || pomodoroTotalCount == pomodoroNum) {
          //pomodoroNum < longBreakAfter!
          //pomodoroPerSet == 0) {
          _status = PomodoroStatus.pausedLongBreak;
          remaningTime = (longBreak ?? longBreakTime);
          _streamController.sink.add(remaningTime);

          if (autoStartBreak!) {
            mainBtnText = language == 'ar' ? 'توقف' : 'PAUSE'; //"btnTextPause".tr;
            startLongBreak();
          } else {
            mainBtnText = language == 'ar' ? 'خذ استراحة طويلة' : 'TAKE LONG BREAK'; //"btnTextStartLongBreak".tr;
          }
          update();
        } else {
          remaningTime = (shortBreak ?? shortBreakTime);
          _streamController.sink.add(remaningTime);
          _status = PomodoroStatus.pausedShortBreak;
          if (autoStartBreak!) {
            mainBtnText = language == 'ar' ? 'توقف' : 'PAUSE'; //"btnTextPause".tr;
            startShortBreak();
          } else {
            mainBtnText = language == 'ar' ? 'خذ استراحة قصيرة' : 'TAKE SHORT BREAK';
            //"btnTextStartShortBreak".tr;
          }

          update();
        }
      }
    });
  }

  startShortBreak() {
    startBreak(false);
  }

  startLongBreak() {
    startBreak(true);
  }

  startBreak(bool isLongBreak) {
    cancelTimer();
    _status = isLongBreak ? PomodoroStatus.runningLongBreak : PomodoroStatus.runningShortBreak;
    mainBtnText = language == 'ar' ? 'توقف' : 'PAUSE'; //"btnTextPause".tr;
    update();

    playSilenceSound();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remaningTime > 0) {
        remaningTime--;
        _streamController.sink.add(remaningTime);
        if (showNotification! &&
            (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.linux ||
                defaultTargetPlatform == TargetPlatform.macOS)) {
          notifyHelper.displayNotification(title: appName, body: formatTime(remaningTime));
        }
        update();
      } else {
        stopSilenceSound();
        playSound();
        vibrate();
        cancelTimer();
        remaningTime = (pomodoroTimer ?? pomodoroTotalTime);
        _streamController.sink.add(remaningTime);

        _status = isLongBreak ? PomodoroStatus.setFinished : PomodoroStatus.pausedPomodoro;
        mainBtnText = language == 'ar' ? 'بدأ المؤقت' : 'START POMODORO';
        //     ? (language == 'ar' ? 'خذ استراحة طويلة' : 'TAKE LONG BREAK')
        //     : (language == 'ar' ? 'بدأ المؤقت' : 'START POMODORO'); //"btnTextStartNewSet".tr : "btnTextStart".tr;

        if (autoStartBreak! && pomodoroNum < pomodoroTotalCount) {
          startPomodoroCountdown();
        }
        update();
      }
    });
  }

  pausePomdoroCountdown() {
    _status = PomodoroStatus.pausedPomodoro;
    cancelTimer();
    mainBtnText = language == 'ar' ? 'استئناف' : 'RESUME POMODORO'; //"btnTextResumePomodoro".tr;
    update();
  }

  pauseShortBreak() {
    _status = PomodoroStatus.pausedShortBreak;
    pausedBreakCountdown();
  }

  pauseLongBreak() {
    _status = PomodoroStatus.pausedLongBreak;
    pausedBreakCountdown();
  }

  pausedBreakCountdown() {
    cancelTimer();
    mainBtnText = language == 'ar' ? 'استئناف الاستراحة' : 'RESUME BREAK';
    //"btnTextResumeBreak".tr;
    update();
  }

  resetBtnPressed() {
    pomodoroNum = 0;
    setNum = 0;
    cancelTimer();
    stopCountdown();
    notifyHelper.cancelNotification();
  }

  stopCountdown() {
    _status = PomodoroStatus.pausedPomodoro;
    mainBtnText = language == 'ar' ? 'بدأ المؤقت' : 'START POMODORO'; //"btnTextStart".tr;
    isStarted = false;
    remaningTime = (pomodoroTimer ?? pomodoroTotalTime);
    _streamController.sink.add(remaningTime);
    Wakelock.disable();
    update();
  }

  cancelTimer() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  loadAudio() async {
    // var load = await audioCache.load("bell.mp3");
  }

  playSound() {
    if (isAlarmOn!) {
      audioPlayer.dispose();
      audioPlayer = AudioPlayer();
      audioPlayer.setReleaseMode(ReleaseMode.stop);
      audioPlayer.play(AssetSource('sounds/bell.mp3'));
      audioPlayer.onPlayerComplete.listen((event) {
        audioPlayer.dispose();
      });
    }
  }

  playSilenceSound() {
    silenceAudioPlayer.dispose();
    silenceAudioPlayer = AudioPlayer();
    silenceAudioPlayer.play(AssetSource('sounds/silence.mp3'));
    silenceAudioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  stopSilenceSound() {
    silenceAudioPlayer.stop();
    silenceAudioPlayer.dispose();
  }

  vibrate() async {
    if (isVibrationOn!) {
      bool? hasCustomVibration = await Vibration.hasCustomVibrationsSupport();
      if (hasCustomVibration != null && hasCustomVibration) {
        Vibration.vibrate(duration: 1500);
      } else {
        Vibration.vibrate();
        await Future.delayed(const Duration(milliseconds: 200));
        Vibration.vibrate();
        await Future.delayed(const Duration(milliseconds: 200));
        Vibration.vibrate();
      }
      // }
    }
  }

  void savePomodoPerSetCount(String key, int value) async {
    await prefs.setInt(key, value);
    if (!isStarted) {
      pomodoroTotalCount = value;
      update();
    }
  }

  void savePomodoTimer(String key, int value) async {
    await prefs.setInt(key, value);
    if (!isStarted) {
      pomodoroTimer = value * 60;
      remaningTime = value * 60;
      _streamController.sink.add(remaningTime);
      update();
    }
  }

  void saveShortBreak(String key, int value) async {
    await prefs.setInt(key, value);
    if (!isStarted) {
      shortBreak = value * 60;
      update();
    }
  }

  void saveLongBreak(String key, int value) async {
    await prefs.setInt(key, value);
    if (!isStarted) {
      longBreak = value * 60;
      update();
    }
  }

  void saveLongBreakAfter(String key, int value) async {
    await prefs.setInt(key, value);
    if (!isStarted) {
      longBreakAfter = value;
      update();
    }
  }

  void saveShowNotification(String key, bool value) async {
    await prefs.setBool(key, value);
    try {
      notifyHelper.cancelNotification();
    } catch (e) {
      print(e);
    }
    if (!isStarted) {
      showNotification = value;
      update();
    }
  }

  void saveAutoStarted(String key, bool value) async {
    await prefs.setBool(key, value);
    // if (!isStarted) {
    autoStartBreak = value;
    update();
    // }
  }

  void saveAlarm(String key, bool value) async {
    await prefs.setBool(key, value);
    // if (!isStarted) {
    isAlarmOn = value;
    update();
    // }
  }

  void saveVibration(String key, bool value) async {
    await prefs.setBool(key, value);
    // if (!isStarted) {
    isVibrationOn = value;
    update();
    // }
  }

  void saveLanguage(String key, bool value) async {
    await prefs.setBool(key, value);
    if (!isStarted) {
      mainBtnText = language != 'ar' ? 'بدأ المؤقت' : 'START POMODORO';
    }
    language = value ? 'en' : 'ar';
    String langCode = language!;

    Locale locale = Locale(langCode);
    await prefs.setString(key, locale.languageCode);
    await Get.updateLocale(locale);
    update();
    // }
  }

  void saveAwake(String key, bool value) async {
    await prefs.setBool(key, value);
    // if (!isStarted) {
    isAwakeOn = value;
    update();
    if (isAwakeOn!) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
    // }
  }

  String formatTime(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondString = remainingSeconds < 10 ? "0$remainingSeconds" : remainingSeconds.toString();
    String remainingMinutesString = roundedMinutes < 10 ? "0$roundedMinutes" : roundedMinutes.toString();

    return "$remainingMinutesString:$remainingSecondString";
  }
}
