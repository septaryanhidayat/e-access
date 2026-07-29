import 'package:flutter/material.dart';

class DashboardSiswaScreen extends StatelessWidget {
  const DashboardSiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Siswa')),
      body: const Center(
        child: Text('Welcome, Siswa!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
