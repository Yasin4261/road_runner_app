import 'package:flutter/material.dart';

class ShiftsScreen extends StatelessWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vardiyalar'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Vardiyalar Sayfası',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

