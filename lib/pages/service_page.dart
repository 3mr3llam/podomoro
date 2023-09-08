import 'dart:async';

import 'package:flutter/material.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final SetTimer _setTimer = SetTimer();

  @override
  void initState() {
    _setTimer.start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<int>(
        stream: _setTimer.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<int> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return Center(
                child: Text(snapshot.data.toString(), style: const TextStyle(color: Colors.red, fontSize: 40)),
              );
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}

class SetTimer {
  int _seconds = 0;
  final _streamController = StreamController<int>.broadcast();
  Timer? _timer;

  // Getters
  Stream<int> get stream => _streamController.stream;

  // Setters
  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      _updateSeconds();
    });
  }

  void _updateSeconds() {
    // stop counting after one hour
    if (_seconds < 3600) {
      _streamController.sink.add(_seconds);
    }
  }
}
