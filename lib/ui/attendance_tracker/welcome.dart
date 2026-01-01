import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo1.png'),
            SizedBox(height: 20),
            Image.asset('assets/quickcheck.png'),
            SizedBox(height: 10),
            Text(
              'Attendance Tracker',
              style: TextStyle(fontSize: 16, color: Color(0xFF5597FF), letterSpacing: 6),
            ),
          ],
          // child: Text(
          //   'Attendance Tracker',
          //   style: TextStyle(fontSize: 16, color: Color(0xFF5597FF)),
          // ),
        ),
      ),
    );
  }
}
