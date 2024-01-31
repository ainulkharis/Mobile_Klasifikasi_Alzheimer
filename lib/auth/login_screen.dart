import 'package:flutter/material.dart';
import 'package:e_alzaimer/main.dart';
import 'package:e_alzaimer/helpers/database.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:e_alzaimer/auth/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                  width: 120,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _handleLogin(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 250, 250, 250)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    _navigateToSignup(context);
                  },
                  child: Text(
                    'Belum punya akun? Daftar disini',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      DatabaseHelper dbHelper = DatabaseHelper();
      sqflite.Database? db;

      try {
        db = await dbHelper.initDatabase();
      } catch (error) {
        print('Error opening database: $error');
        return;
      }

      try {
        List<Map<String, dynamic>> result = await db!.query(
          'User',
          where: 'username = ? AND password = ?',
          whereArgs: [usernameController.text, passwordController.text],
        );

        if (result.isNotEmpty) {
          // Login successful
          print('Login successful');
          _navigateToHome(context);
        } else {
          // Login failed
          print('Login failed: Invalid username or password');
          // Berikan feedback UI, misalnya dengan menggunakan SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: Invalid username or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        print('Error querying database: $error');
      }
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  void _navigateToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }
}
