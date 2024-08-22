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
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyClH5TsZfED3gTQTzuaFSMnGVi1hwqPhM4',
    appId: '1:744760460637:web:24b7cbbf33cb2c6bbdd4b4',
    messagingSenderId: '744760460637',
    projectId: 'securip-60020',
    authDomain: 'securip-60020.firebaseapp.com',
    storageBucket: 'securip-60020.appspot.com',
    measurementId: 'G-T87RKXHXT7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGvS0IrP5hp4ZIgAYsEhZwjlrpKK7Awyw',
    appId: '1:744760460637:android:c1452b820a20c359bdd4b4',
    messagingSenderId: '744760460637',
    projectId: 'securip-60020',
    storageBucket: 'securip-60020.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4H2oGh7jO9nqM7jg5BfgjaLkKxtGno1Y',
    appId: '1:744760460637:ios:7a51589490105fc9bdd4b4',
    messagingSenderId: '744760460637',
    projectId: 'securip-60020',
    storageBucket: 'securip-60020.appspot.com',
    iosBundleId: 'com.example.securip',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD4H2oGh7jO9nqM7jg5BfgjaLkKxtGno1Y',
    appId: '1:744760460637:ios:7a51589490105fc9bdd4b4',
    messagingSenderId: '744760460637',
    projectId: 'securip-60020',
    storageBucket: 'securip-60020.appspot.com',
    iosBundleId: 'com.example.securip',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyClH5TsZfED3gTQTzuaFSMnGVi1hwqPhM4',
    appId: '1:744760460637:web:62d0f9819e5a79f7bdd4b4',
    messagingSenderId: '744760460637',
    projectId: 'securip-60020',
    authDomain: 'securip-60020.firebaseapp.com',
    storageBucket: 'securip-60020.appspot.com',
    measurementId: 'G-8LGLFJB2EW',
  );

}