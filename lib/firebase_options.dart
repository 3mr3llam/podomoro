// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCyUX2a6V05RS06R9gjfUfiHmqXfkRcTl0',
    appId: '1:81814823510:web:6ef6890c271313de1e11f7',
    messagingSenderId: '81814823510',
    projectId: 'test-messaging-service',
    authDomain: 'test-messaging-service.firebaseapp.com',
    databaseURL: 'https://test-messaging-service.firebaseio.com',
    storageBucket: 'test-messaging-service.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHL4LEwFZncS1PRcTMhT5eS6axnqHXkRI',
    appId: '1:81814823510:android:19131524c790bc611e11f7',
    messagingSenderId: '81814823510',
    projectId: 'test-messaging-service',
    databaseURL: 'https://test-messaging-service.firebaseio.com',
    storageBucket: 'test-messaging-service.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVlX5fI7Q1jPXmoYeOoGqvX1F-1F_QICQ',
    appId: '1:81814823510:ios:21227eb3b83fb3021e11f7',
    messagingSenderId: '81814823510',
    projectId: 'test-messaging-service',
    databaseURL: 'https://test-messaging-service.firebaseio.com',
    storageBucket: 'test-messaging-service.appspot.com',
    androidClientId: '81814823510-aimgru8lf32biqdga23if9rdqo829bhv.apps.googleusercontent.com',
    iosClientId: '81814823510-gepltr8tpeib4hjspsb3cpqmr6stnccc.apps.googleusercontent.com',
    iosBundleId: 'com.pharaohapp.podomoro',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVlX5fI7Q1jPXmoYeOoGqvX1F-1F_QICQ',
    appId: '1:81814823510:ios:21227eb3b83fb3021e11f7',
    messagingSenderId: '81814823510',
    projectId: 'test-messaging-service',
    databaseURL: 'https://test-messaging-service.firebaseio.com',
    storageBucket: 'test-messaging-service.appspot.com',
    androidClientId: '81814823510-aimgru8lf32biqdga23if9rdqo829bhv.apps.googleusercontent.com',
    iosClientId: '81814823510-gepltr8tpeib4hjspsb3cpqmr6stnccc.apps.googleusercontent.com',
    iosBundleId: 'com.pharaohapp.podomoro',
  );
}