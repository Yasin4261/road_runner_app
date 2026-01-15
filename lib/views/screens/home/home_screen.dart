import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/core/enums/location_status.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/viewmodels/home_viewmodel.dart';
import 'package:road_runner_app/views/widgets/map/map_types.dart';
import 'package:road_runner_app/views/widgets/dialogs/location_permission_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<HomeViewModel>()..initializeLocation(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent>
    with WidgetsBindingObserver {
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final viewModel = context.read<HomeViewModel>();
      viewModel.recheckPermissionAfterSettings();
    }
  }

  Future<void> _showLocationPermissionDialog(LocationStatus status) async {
    if (_isDialogShowing) return;
    if (status == LocationStatus.granted) return;
    if (!mounted) return;

    _isDialogShowing = true;

    final viewModel = context.read<HomeViewModel>();

    await LocationPermissionDialog.show(
      context,
      status: status,
      onActionPressed: () async {
        await viewModel.handleLocationPermissionAction();
      },
      onDismiss: () {
        viewModel.clearLocationStatus();
      },
    );

    _isDialogShowing = false;
  }

  Future<void> _onLocationBannerTap() async {
    try {
      final viewModel = context.read<HomeViewModel>();
      final status = await viewModel.checkLocationStatus();

      debugPrint('Location status: $status');

      if (!mounted) return;

      if (status != LocationStatus.granted) {
        await _showLocationPermissionDialog(status);
      }
    } catch (e) {
      debugPrint('Error checking location: $e');
      if (!mounted) return;

      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konum servisi başlatılamadı. Uygulamayı yeniden başlatın.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Konum alınıyor...'),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Map
              if (viewModel.mapProvider != null)
                viewModel.mapProvider!.buildMap(
                  position: viewModel.currentPosition,
                  onPositionChanged: viewModel.onMapPositionChanged,
                  userLocation: viewModel.userLocation,
                ),

              // Top controls
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Map Provider Toggle
                    _MapProviderToggle(
                      currentType: viewModel.mapProviderType,
                      onToggle: viewModel.toggleMapProvider,
                    ),

                    // Location Banner
                    if (!viewModel.hasLocationPermission)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _LocationBanner(
                          onTap: _onLocationBannerTap,
                        ),
                      ),
                  ],
                ),
              ),

              // My Location Button
              Positioned(
                bottom: 120,
                right: 16,
                child: _MyLocationButton(
                  isLoading: viewModel.isLoadingLocation,
                  onPressed: () async {
                    if (viewModel.hasLocationPermission) {
                      await viewModel.goToMyLocation();
                    } else {
                      await _onLocationBannerTap();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Location warning banner
class _LocationBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _LocationBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('Location banner tapped!'); // Debug log
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.location_off, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Konum izni gerekli',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

/// Map provider toggle button
class _MapProviderToggle extends StatelessWidget {
  final MapProviderType currentType;
  final VoidCallback onToggle;

  const _MapProviderToggle({
    required this.currentType,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: AppColors.surface,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(currentType.icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                currentType.displayName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.swap_horiz, size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// My location FAB
class _MyLocationButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _MyLocationButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'my_location',
      onPressed: isLoading ? null : onPressed,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primary,
      elevation: 4,
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.my_location),
    );
  }
}

