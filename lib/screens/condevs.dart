import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConDevsPage extends StatefulWidget {
  const ConDevsPage({super.key});

  @override
  _ConDevsPageState createState() => _ConDevsPageState();
}

class _ConDevsPageState extends State<ConDevsPage> {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> _airQualityStream =
      FirebaseFirestore.instance
          .collection('Image-Stat')
          .doc('Air-Quality')
          .snapshots();

  final Stream<DocumentSnapshot<Map<String, dynamic>>> _imageDetectStream =
      FirebaseFirestore.instance
          .collection('Image-Stat')
          .doc('Image-Detect')
          .snapshots();

  // Initialize FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Previous status values to track changes
  bool? _previousAirQualityStatus;
  bool? _previousImageDetectStatus;

  @override
  void initState() {
    super.initState();

    // Initialize notification plugin with correct icon
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _airQualityStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    airQualitySnapshot) {
              if (airQualitySnapshot.hasError) {
                return const Center(child: Text('Error: Something went wrong'));
              }

              if (airQualitySnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final airQualityData =
                  airQualitySnapshot.data!.data() as Map<String, dynamic>;
              final airQualityName = airQualityData['Name'];
              final bool airQualityStatus = airQualityData['Status'];

              // Check for change in status
              if (_previousAirQualityStatus != null && 
                  _previousAirQualityStatus != airQualityStatus &&
                  !airQualityStatus) {
                showNotification(
                    title: 'Air Quality Disconnected',
                    body: 'The Air Quality device is no longer connected.');
              }

              _previousAirQualityStatus = airQualityStatus;

              return ListTile(
                title: const Text('Air Quality'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: $airQualityName'),
                    Text(
                        'Status: ${airQualityStatus ? 'Connected' : 'Disconnected'}'),
                  ],
                ),
              );
            },
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _imageDetectStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    imageDetectSnapshot) {
              if (imageDetectSnapshot.hasError) {
                return const Center(child: Text('Error: Something went wrong'));
              }

              if (imageDetectSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final imageDetectData =
                  imageDetectSnapshot.data!.data() as Map<String, dynamic>;
              final imageDetectName = imageDetectData['Name'];
              final bool imageDetectStatus = imageDetectData['Status'];

              // Check for change in status
              if (_previousImageDetectStatus != null && 
                  _previousImageDetectStatus != imageDetectStatus &&
                  !imageDetectStatus) {
                showNotification(
                    title: 'Image Detect Disconnected',
                    body: 'The Image Detect device is no longer connected.');
              }

              _previousImageDetectStatus = imageDetectStatus;

              return ListTile(
                title: const Text('Image Detect'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: $imageDetectName'),
                    Text(
                        'Status: ${imageDetectStatus ? 'Connected' : 'Disconnected'}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Function to show a notification
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    // Log a message to indicate a notification is being sent
    print('Sending notification: $title - $body');

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',  // Ensure the correct icon is referenced
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
