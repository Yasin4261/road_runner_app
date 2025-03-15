import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/constants/colors.dart';
import 'package:road_runner_app/constants/dimensions.dart';
import 'package:road_runner_app/constants/text_styles.dart';
import 'package:road_runner_app/viewmodels/profile_viewmodel.dart';
import 'package:road_runner_app/widgets/custom_drawer.dart'; // Import the drawer widget

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final runnerId = "runner_id"; // Bu runnerId'yi uygun şekilde alın

    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..fetchRunnerProfile(runnerId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        drawer: const CustomDrawer(), // Add the drawer widget
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Consumer<ProfileViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final runner = viewModel.runner;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: runner?.profileImageUrl != null
                          ? NetworkImage(runner!.profileImageUrl!)
                          : null,
                      child: runner?.profileImageUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    _buildProfileItem('Name', runner?.name),
                    _buildProfileItem('Phone', runner?.phone),
                    _buildProfileItem('Email', runner?.email),
                    _buildProfileItem(
                        'Vehicle Type', runner?.vehicleType?.toString()),
                    _buildProfileItem(
                        'Current Status', runner?.currentStatus?.toString()),
                    _buildProfileItem(
                        'Shift Start Time', runner?.shiftStartTime),
                    _buildProfileItem(
                        'Queue Position', runner?.queuePosition?.toString()),
                    const SizedBox(height: AppDimensions.paddingLarge),
                    ElevatedButton(
                      onPressed: () async {
                        // Logout işlemi
                        await viewModel.logout();
                        context.go('/');
                      },
                      child: const Text('Çıkış Yap'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? 'Not available'),
        ],
      ),
    );
  }
}
