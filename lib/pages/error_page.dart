import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;

  const ErrorPage({
    Key? key,
    this.errorDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/error.jpg'),
              Text(
                kDebugMode ? (errorDetails != null ? errorDetails!.summary.toString() : '') : 'Oups! Something went wrong!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: kDebugMode ? Colors.red : Colors.black, fontWeight: FontWeight.bold, fontSize: 21),
              ),
              const SizedBox(height: 12),
              const Text(
                kDebugMode
                    ? 'https://docs.flutter.dev/testing/errors'
                    : "We encountered an error and we've notified our engineering team about it. Sorry for the inconvenience caused.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
