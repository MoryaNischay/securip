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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool? _previousAirQualityStatus;
  bool? _previousImageDetectStatus;

  @override
  void initState() {
    super.initState();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 183, 125),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(176, 227, 11, 94),
        centerTitle: true,
        title: const Text('Connected Devices',
            style: TextStyle(
              fontSize: 24.0,
            )),
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

              if (airQualitySnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final airQualityData =
                  airQualitySnapshot.data!.data() as Map<String, dynamic>;
              final airQualityName = airQualityData['Name'];
              final bool airQualityStatus = airQualityData['Status'];

              if (_previousAirQualityStatus != null &&
                  _previousAirQualityStatus != airQualityStatus &&
                  !airQualityStatus) {
                showNotification(
                    title: 'Air Quality Disconnected',
                    body: 'The Air Quality device is no longer connected.');
              }

              _previousAirQualityStatus = airQualityStatus;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  child: Card(
                    
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$airQualityName',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Status: ${airQualityStatus ? 'Connected' : 'Disconnected'}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: airQualityStatus
                                    ? Colors.green
                                    : Colors
                                        .red, // Green for connected, red for disconnected
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

              if (imageDetectSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final imageDetectData =
                  imageDetectSnapshot.data!.data() as Map<String, dynamic>;
              final imageDetectName = imageDetectData['Name'];
              final bool imageDetectStatus = imageDetectData['Status'];

              if (_previousImageDetectStatus != null &&
                  _previousImageDetectStatus != imageDetectStatus &&
                  !imageDetectStatus) {
                showNotification(
                    title: 'Image Detect Disconnected',
                    body: 'The Image Detect device is no longer connected.');
              }

              _previousImageDetectStatus = imageDetectStatus;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$imageDetectName',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Status: ${imageDetectStatus ? 'Connected' : 'Disconnected'}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: imageDetectStatus
                                    ? Colors.green
                                    : Colors
                                        .red, // Green for connected, red for disconnected
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    print('Sending notification: $title - $body');

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
