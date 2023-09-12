import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppInit extends StatefulWidget {
  final Widget Function(RateMyApp) builder;
  const RateAppInit({Key? key, required this.builder}) : super(key: key);

  @override
  State<RateAppInit> createState() => _RateAppInitState();
}

class _RateAppInitState extends State<RateAppInit> {
  RateMyApp? _rateMyApp;
  PackageInfo? packageInfo;
  String? packageName;

  @override
  void initState() {
    super.initState();
    getPackgename();
  }

  getPackgename() async {
    packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      packageName = packageInfo!.packageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
      rateMyApp: RateMyApp(
        googlePlayIdentifier: packageName,
        appStoreIdentifier: packageName,
      ),
      onInitialized: (context, rateMyApp) {
        setState(() {
          _rateMyApp = rateMyApp;
        });
      },
      builder: (context) {
        return _rateMyApp == null
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : widget.builder(_rateMyApp!);
      },
    );
  }
}
