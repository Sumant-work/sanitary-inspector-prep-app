import 'package:flutter/material.dart';

class LiveTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🔒 Live Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 50),
            SizedBox(height: 10),
            Text('Coming Soon: Live Test Feature', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
