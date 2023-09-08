import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/utils/constants.dart';

class XMenuController extends GetxController with GetSingleTickerProviderStateMixin {
  // final TickerProvider vsync;
  late AnimationController? _animationController;
  MenuState state = MenuState.closed;

  // MenuController({required this.vsync}) : _animationController = AnimationController(vsync: vsync) {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _animationController = AnimationController(vsync: this)
      ..duration = const Duration(milliseconds: menuAnimationDuration)
      ..addListener(() {
        update();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        update();
      });
  }

  @override
  onClose() {
    _animationController!.dispose();
    super.onClose();
  }

  get percentOpen {
    return _animationController!.value;
  }

  open() {
    _animationController!.forward();
  }

  close() {
    _animationController!.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
