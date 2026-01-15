import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/core/theme/app_text_styles.dart';
import 'package:road_runner_app/viewmodels/profile_viewmodel.dart';
import 'package:road_runner_app/views/widgets/map/osm_tile_providers.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<ProfileViewModel>()..init(),
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Header
              const _ProfileHeader(),
              const SizedBox(height: 24),

              // Settings Section
              Text(
                'Ayarlar',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 12),

              // Map Style Setting
              _SettingsCard(
                title: 'Harita Stili',
                subtitle: viewModel.selectedTileProvider.name,
                icon: Icons.map_outlined,
                onTap: () => _showMapStylePicker(context, viewModel),
              ),

              const SizedBox(height: 24),

              // App Info
              Text(
                'Uygulama',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 12),

              _SettingsCard(
                title: 'Versiyon',
                subtitle: '1.0.0',
                icon: Icons.info_outline,
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMapStylePicker(BuildContext context, ProfileViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MapStylePicker(
        selectedProvider: viewModel.selectedTileProvider,
        providers: viewModel.availableTileProviders,
        onSelected: (provider) {
          viewModel.setTileProvider(provider);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kullanıcı',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 4),
                Text(
                  'Road Runner Kurye',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _SettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapStylePicker extends StatelessWidget {
  final OsmTileProvider selectedProvider;
  final List<OsmTileProvider> providers;
  final ValueChanged<OsmTileProvider> onSelected;

  const _MapStylePicker({
    required this.selectedProvider,
    required this.providers,
    required this.onSelected,
  });

  IconData _getIconForProvider(OsmTileProvider provider) {
    switch (provider.name) {
      case 'Carto Voyager':
        return Icons.explore;
      case 'Carto Light':
        return Icons.light_mode;
      case 'Carto Dark':
        return Icons.dark_mode;
      case 'OpenStreetMap':
        return Icons.public;
      default:
        return Icons.map;
    }
  }

  String _getDescriptionForProvider(OsmTileProvider provider) {
    switch (provider.name) {
      case 'Carto Voyager':
        return 'Modern ve temiz görünüm';
      case 'Carto Light':
        return 'Açık ve minimal tasarım';
      case 'Carto Dark':
        return 'Karanlık mod için ideal';
      case 'OpenStreetMap':
        return 'Klasik OpenStreetMap stili';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Harita Stili Seçin',
              style: AppTextStyles.h3,
            ),
          ),

          // Options
          ...providers.map((provider) {
            final isSelected = provider.name == selectedProvider.name;
            return _MapStyleOption(
              provider: provider,
              icon: _getIconForProvider(provider),
              description: _getDescriptionForProvider(provider),
              isSelected: isSelected,
              onTap: () => onSelected(provider),
            );
          }),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MapStyleOption extends StatelessWidget {
  final OsmTileProvider provider;
  final IconData icon;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _MapStyleOption({
    required this.provider,
    required this.icon,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : null,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

