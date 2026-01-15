import 'package:flutter/material.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paketlerim'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Paketlerim Sayfası',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

