import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/utils/constants.dart';

import 'package:webviewx/webviewx.dart';
// import 'dart:ui' as ui;

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late WebViewXController webviewController;
  String initialContent = "";
  Size get screenSize => MediaQuery.of(context).size;

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: _buildWebViewX(),
        ),
      ),
    );
  }

  Widget _buildWebViewX() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: 'assets/web/privacy.html',
      initialSourceType: SourceType.html,
      height: screenSize.height,
      width: screenSize.width, //min(screenSize.width * 0.8, 1024),
      onWebViewCreated: (controller) {
        webviewController = controller;
        controller.loadContent(
          'assets/web/privacy.html',
          SourceType.html,
          fromAssets: true,
        );
      },
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
    );
  }
}

/*
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late final WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'about:blank',
          zoomEnabled: false,
          gestureNavigationEnabled: true,
          allowsInlineMediaPlayback: true,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets('assets/web/privacy.html');
          },
          onWebResourceError: (WebResourceError error) async {
            _loadHtmlFromAssets('assets/web/404.html');
          },
        ),
      ),
    );
  }

  _loadHtmlFromAssets(String filename) async {
    String fileText = await rootBundle.loadString(filename);
    _controller.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }
}
*/