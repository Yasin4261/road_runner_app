import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merhaba, Dünyamız Monochrome!',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Bu minimalist ve modern tasarımı kullanarak harika bir kullanıcı deneyimi sunabilirsiniz.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
