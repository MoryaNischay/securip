import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConDevsPage extends StatefulWidget {
  const ConDevsPage({super.key});

  @override
  _ConDevsPageState createState() => _ConDevsPageState();
}

class _ConDevsPageState extends State<ConDevsPage> {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> _deviceStream =
      FirebaseFirestore.instance.collection('Image-Stat').doc('Air-Quality').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _deviceStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error: Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final deviceData = snapshot.data!.data() as Map<String, dynamic>;
          final name = deviceData['Name'];
          final status = deviceData['Status'];
          print('Name: $name, Status: $status');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: $name'),
                const SizedBox(height: 16.0),
                Text('Status: ${status ? 'Connected' : 'Disconnected'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}