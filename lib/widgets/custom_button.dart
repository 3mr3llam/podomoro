import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final bool isDisabled;

  const CustomButton({Key? key, required this.onTap, required this.text, this.isDisabled = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: MaterialButton(
        color: Colors.orange,
        disabledColor: disabledColor,
        minWidth: 200,
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }
}
