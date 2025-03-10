import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/constants/colors.dart';
import 'package:road_runner_app/constants/dimensions.dart';
import 'package:road_runner_app/constants/text_styles.dart';
import 'package:road_runner_app/viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final runnerId = "runner_id"; // Bu runnerId'yi uygun şekilde alın

    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadRunnerProfile(runnerId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Consumer<ProfileViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.runner == null) {
                  return const Center(
                      child: Text('Kullanıcı bilgileri yüklenemedi.'));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: viewModel.runner!.profileImageUrl != null
                          ? NetworkImage(viewModel.runner!.profileImageUrl!)
                          : null,
                      child: viewModel.runner!.profileImageUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      viewModel.runner!.name ?? 'İsim yok',
                      style: AppTextStyles.headline1,
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      viewModel.runner!.email ?? 'Email yok',
                      style: AppTextStyles.bodyText1,
                    ),
                    const SizedBox(height: AppDimensions.paddingLarge),
                    ElevatedButton(
                      onPressed: () {
                        // Logout işlemi
                        viewModel.logout();
                        Navigator.of(context).pushReplacementNamed('/login');
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
}
