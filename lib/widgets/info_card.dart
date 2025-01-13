import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String content;

  const InfoCard({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
            const Icon(Icons.card_giftcard, size: 28),
          ],
        ),
      ),
    );
  }
}
