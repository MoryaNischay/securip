import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegisterMode = true; // Set default mode to register

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_isRegisterMode) {
          // Register
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        } else {
          // Login
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        }
        // Successful login/registration, navigate to the next screen
        Navigator.pushReplacementNamed(
            context, '/home'); // Replace with your home screen route
      } on FirebaseAuthException catch (e) {
        // Handle login/registration errors
        print('Failed to ${_isRegisterMode ? 'register' : 'login'}: ${e.code}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to ${_isRegisterMode ? 'register' : 'login'}: ${e.code}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 183, 125),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(176, 227, 11, 94),
        centerTitle: true,
        title: const Text('Welcome!', style: TextStyle(fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(176, 227, 11, 94),
                  foregroundColor: Colors.black,
                ),
                onPressed: _submitForm,
                child: Text(_isRegisterMode ? 'Register' : 'Login',
                    style: const TextStyle(fontSize: 15)),
              ),
              const SizedBox(height: 16),
              //align the text to the center
              const Align(
                alignment: Alignment.center,
                child: Text('Already have an account?'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isRegisterMode = !_isRegisterMode;
                  });
                },
                child: Text(_isRegisterMode ? 'Login' : 'Register now!',
                    //underline the text
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
