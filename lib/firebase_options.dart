// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBcC_rX5C3UlbmpGSbJV25cGWTBFkyfVcc',
    appId: '1:403516461349:web:ad471042a8b9cc5fe9cacc',
    messagingSenderId: '403516461349',
    projectId: 'task-app-5df27',
    authDomain: 'task-app-5df27.firebaseapp.com',
    storageBucket: 'task-app-5df27.appspot.com',
    measurementId: 'G-9MG4EXB91S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdKc8Nd9c8O_JV-3pS9yf2CVFwV8CNMnE',
    appId: '1:403516461349:android:5e7242b7fc927af8e9cacc',
    messagingSenderId: '403516461349',
    projectId: 'task-app-5df27',
    storageBucket: 'task-app-5df27.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBcC_rX5C3UlbmpGSbJV25cGWTBFkyfVcc',
    appId: '1:403516461349:web:f5eea9b9eae4ebfee9cacc',
    messagingSenderId: '403516461349',
    projectId: 'task-app-5df27',
    authDomain: 'task-app-5df27.firebaseapp.com',
    storageBucket: 'task-app-5df27.appspot.com',
    measurementId: 'G-WCFNHT017C',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQbd-ypdYxbsDgg0T9OXh5d_-TPZvebM4',
    appId: '1:403516461349:ios:5a03e5a1a6912a07e9cacc',
    messagingSenderId: '403516461349',
    projectId: 'task-app-5df27',
    storageBucket: 'task-app-5df27.appspot.com',
    iosBundleId: 'com.serenitytasks.product',
  );
}
