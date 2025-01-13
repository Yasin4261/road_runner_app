import 'package:flutter/material.dart';
import 'package:road_runner_app/widgets/custom_app_bar.dart';
import 'package:road_runner_app/widgets/welcome_message.dart';
import 'package:road_runner_app/widgets/start_button.dart';
import 'package:road_runner_app/widgets/input_field.dart';
import 'package:road_runner_app/widgets/info_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Monochrome Vibes'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            WelcomeMessage(),
            SizedBox(height: 20),
            StartButton(),
            SizedBox(height: 20),
            InputField(labelText: 'Adınızı Girin', hintText: 'John Doe'),
            SizedBox(height: 20),
            InfoCard(content: 'Bu bir kart widget.'),
          ],
        ),
      ),
    );
  }
}
