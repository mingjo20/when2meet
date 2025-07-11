import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Screen')),
      body: const Center(
        child: Text('메인 화면입니다', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
