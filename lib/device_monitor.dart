import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DeviceMonitorService {
  static final DeviceMonitorService _instance =
      DeviceMonitorService._internal();

  factory DeviceMonitorService() {
    return _instance;
  }

  DeviceMonitorService._internal() {
    _fetchData().then((_) {
      _initializeNotifications();
      _monitorAirQuality();
      _monitorImageDetect();
    });
  }

  final Stream<DocumentSnapshot<Map<String, dynamic>>> airQualityStream =
      FirebaseFirestore.instance
          .collection('Image-Stat')
          .doc('Air-Quality')
          .snapshots();

  final Stream<DocumentSnapshot<Map<String, dynamic>>> imageDetectStream =
      FirebaseFirestore.instance
          .collection('Image-Stat')
          .doc('Image-Detect')
          .snapshots();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _previousAirQualityStatus = false; // Initialize with a default value
  bool _previousImageDetectStatus = false; // Initialize with a default value

  // Initialize the FlutterLocalNotificationsPlugin
  void _initializeNotifications() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Force data retrieval on initialization
  Future<void> _fetchData() {
    return airQualityStream.first.then((snapshot) {
      // Process the first snapshot of airQualityStream
    }).then((_) {
      return imageDetectStream.first;
    }).then((snapshot) {
      // Process the first snapshot of imageDetectStream
    });
  }

  void _monitorAirQuality() {
    airQualityStream.listen((snapshot) {
      final airQualityData = snapshot.data()!;
      final bool airQualityStatus = airQualityData['Status'];

      if (_previousAirQualityStatus != airQualityStatus && !airQualityStatus) {
        _showNotification(
          title: 'Air Quality Disconnected',
          body: 'The Air Quality device is no longer connected.',
        );
      }

      _previousAirQualityStatus = airQualityStatus;
    });
  }

  void _monitorImageDetect() {
    imageDetectStream.listen((snapshot) {
      final imageDetectData = snapshot.data()!;
      final bool imageDetectStatus = imageDetectData['Status'];

      if (_previousImageDetectStatus != imageDetectStatus &&
          !imageDetectStatus) {
        _showNotification(
          title: 'Image Detect Disconnected',
          body: 'The Image Detect device is no longer connected.',
        );
      }

      _previousImageDetectStatus = imageDetectStatus;
    });
  }

  // Function to show a notification
  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
