import 'package:flutter/material.dart';

import 'api_service.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // _authService.initUniLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EXCO Portal'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              try {
                await _authService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logout failed: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to EXCO Portal',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Add your main content here
          ],
        ),
      ),
    );
  }
}
