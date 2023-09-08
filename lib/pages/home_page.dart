import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro_timer/controllers/menu_controller.dart';
import 'package:pomodoro_timer/controllers/pomodoro_controller.dart';
import 'package:pomodoro_timer/notification_service.dart';
import 'package:pomodoro_timer/pages/menu_page.dart';
import 'package:pomodoro_timer/utils/constants.dart';
import 'package:pomodoro_timer/widgets/custom_button.dart';
import 'package:pomodoro_timer/widgets/pomodoro_icons.dart';
import 'package:pomodoro_timer/widgets/zoom_scaffold.dart';
import 'package:rate_my_app/rate_my_app.dart';

class HomePage extends StatefulWidget {
  final RateMyApp? rateMyApp;

  const HomePage({Key? key, this.rateMyApp}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PomodoroController podoController = Get.find<PomodoroController>();
  late XMenuController xmenuController;
  final ScrollController _scrollController = ScrollController();
  late NotifyHelper notifyHelper;
  final service = FlutterBackgroundService();

  String authStatus = 'Unknown';
  String mainBtnText = "btnTextStart".tr;

  Future<bool> _willPopCallback() async {
    bool goBack = false;

    // if (canNavigate) {
    //   _controller.goBack();
    //   return false;
    // } else {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'confirmation'.tr,
          style: const TextStyle(color: Colors.purple),
          textAlign: Get.locale!.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
        ),
        // Are you sure?
        content: Text('exitapp'.tr, textAlign: Get.locale!.languageCode == 'ar' ? TextAlign.right : TextAlign.left),
        // Do you want to go back?
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // SystemNavigator.pop();
              Navigator.of(context).pop();

              setState(() {
                goBack = false;
              });
            },
            child: Text("no".tr, textAlign: TextAlign.center), // No
          ),
          TextButton(
            onPressed: () {
              // Navigator.of(context).pop();
              // Navigator.of(context, rootNavigator: true).maybePop(false);
              SystemNavigator.pop();
              setState(() {
                goBack = true;
              });
            },
            child: Text(
              "yes".tr,
              textAlign: TextAlign.center,
            ), // Yes
          ),
        ],
      ),
    );

    if (goBack) Navigator.pop(context); // If user press Yes pop the page
    return goBack;
    // }
  }

  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
        setState(() => authStatus = '$status');
      }
    } on PlatformException {
      setState(() => authStatus = 'PlatformException was thrown');
    }

    // var uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  }

  @override
  void initState() {
    // FlutterNativeSplash.remove();
    if (mounted) {}
    Get.lazyPut(() => XMenuController(), fenix: true);
    xmenuController = Get.find<XMenuController>();
    podoController.context = context;
    notifyHelper = NotifyHelper(context);
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    // Get.lazyPut(() => PomodoroController(), fenix: true);

    WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var radius = width > height ? height * 0.2 : width * 0.4;
    radius = 120; //radius > 210 ? 200 : radius;

    return GetBuilder(
      init: Get.find<PomodoroController>(),
      builder: (pomodoroController) {
        return GetBuilder(
          init: Get.find<XMenuController>(),
          builder: (menuController) {
            return Scaffold(
              // backgroundColor: bgColor,
              body: SafeArea(
                child: ZoomScaffold(
                  bottomNavBar: null,
                  menuScreen: MenuPage(
                    rateMyApp: widget.rateMyApp!,
                  ),
                  contentScreen: Layout(
                    contentBuilder: (context) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        color: bgColor,
                        child: Center(
                          child: StreamBuilder(
                              stream: podoController.stream,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: ListView(
                                        // shrinkWrap: true,
                                        controller: _scrollController,
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // SizedBox(
                                          //   height: 20.0,
                                          // ),
                                          // Text(
                                          //   "Pomodoro number: ${podoController.pomodoroNum}",
                                          //   style: const TextStyle(fontSize: 32.0, color: Colors.white),
                                          // ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          Center(
                                            child: Text(
                                              "${"set".tr} : ${podoController.setNum}",
                                              style: const TextStyle(fontSize: 22, color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          // Expanded(
                                          // width: radius,
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularPercentIndicator(
                                                progressColor: statusColors[podoController.status],
                                                radius: radius,
                                                lineWidth: 20,
                                                circularStrokeCap: CircularStrokeCap.round,
                                                backgroundColor: Colors.grey.shade300,
                                                percent: podoController.getPomodoroPercentage(),
                                                center: Text(
                                                  podoController.formatTime(podoController.remaningTime),
                                                  style: const TextStyle(fontSize: 40, color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          PomodoroIcons(
                                            total: podoController.pomodoroTotalCount,
                                            done: podoController.pomodoroNum - (podoController.setNum * podoController.pomodoroTotalCount),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // Center(
                                          //   child: Text(
                                          //     statusDescriptions[podoController.status]!,
                                          //     style: const TextStyle(color: Colors.white),
                                          //   ),
                                          // ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomButton(
                                                  onTap: () async {
                                                    /* if (!kIsWeb &&
                                                        (defaultTargetPlatform == TargetPlatform.android ||
                                                            defaultTargetPlatform == TargetPlatform.iOS)) {
                                                      var isRunning = await service.isRunning();
                                                      if (!isRunning) {
                                                        service.startService();
                                                      } else {
                                                        service.invoke('stopService');
                                                      }
                                                    } else {*/
                                                    podoController.mainBtnPressed(null);
                                                    // }
                                                    // NotificationController.createNewNotification();
                                                  },
                                                  text: podoController.mainBtnText,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: CustomButton(
                                                  onTap: () {
                                                    // service.invoke("stopService");
                                                    podoController.resetBtnPressed();
                                                  },
                                                  text: "btnTextReset".tr,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
