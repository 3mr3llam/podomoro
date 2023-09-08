import 'package:flutter/material.dart';

class PomodoroIcons extends StatelessWidget {
  final int total;
  final int done;
  final iconSize = 32.0;

  const PomodoroIcons({Key? key, required this.total, required this.done}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final doneIcon = Icon(
      Icons.beenhere,
      color: Colors.orange,
      size: iconSize,
    );
    final notDoneIcon = Icon(
      Icons.beenhere_outlined,
      color: Colors.grey.shade600,
      size: iconSize,
    );

    List<Icon> icons = [];

    for (var i = 0; i < total; i++) {
      if (i < done) {
        icons.add(doneIcon);
      } else {
        icons.add(notDoneIcon);
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: icons,
          ),
        ),
      ),
    );
  }
}
