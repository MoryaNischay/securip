import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:securip/device_monitor.dart';

class ConDevsPage extends StatefulWidget {
  const ConDevsPage({super.key});

  @override
  _ConDevsPageState createState() => _ConDevsPageState();
}

class _ConDevsPageState extends State<ConDevsPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      DeviceMonitorService().flutterLocalNotificationsPlugin;

  // Access the global streams from DeviceMonitorService
  final Stream<DocumentSnapshot<Map<String, dynamic>>> _airQualityStream =
      DeviceMonitorService().airQualityStream;

  final Stream<DocumentSnapshot<Map<String, dynamic>>> _imageDetectStream =
      DeviceMonitorService().imageDetectStream;

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
}
