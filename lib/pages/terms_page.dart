import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/utils/constants.dart';
import 'package:webviewx/webviewx.dart';
// import 'dart:ui' as ui;

class TermsPage extends StatefulWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
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
      initialContent: 'assets/web/terms_conditions.html',
      initialSourceType: SourceType.html,
      height: screenSize.height,
      width: screenSize.width, //min(screenSize.width * 0.8, 1024),
      onWebViewCreated: (controller) {
        webviewController = controller;
        controller.loadContent(
          'assets/web/terms_conditions.html',
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
