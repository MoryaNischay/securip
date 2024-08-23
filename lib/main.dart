// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/login.dart'; // Replace with your actual file name
import 'screens/condevs.dart';
import './device_monitor.dart'; // Import the DeviceMonitorService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  DeviceMonitorService(); // Start monitoring devices

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Securip', // Replace with your app's name
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!; // Get the logged-in user object

            // Navigate to the home screen with user data
            return HomeScreen(user: user);
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 183, 125),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(176, 227, 11, 94),
        centerTitle: true,
        title: const Text(
          'SecuriPi',
          style: TextStyle(
            fontSize:
                25, // Adjust this value to increase the font size slightly
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Implement your logout logic here
              await FirebaseAuth.instance.signOut();
              // Navigate back to the login page or any other desired screen
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to SECURIPI!, ${user.email}!'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(176, 227, 11, 94),
                foregroundColor: Colors.black,
                // Set the button color to match the AppBar
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConDevsPage()),
                );
              },
              child: const Text('View Device Status'),
            )
          ],
        ),
      ),
    );
  }
}
