import 'package:flutter/material.dart';
import 'package:road_runner_app/core/enums/location_status.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/core/theme/app_text_styles.dart';

/// Location permission dialog widget
class LocationPermissionDialog extends StatelessWidget {
  final LocationStatus status;
  final VoidCallback onActionPressed;
  final VoidCallback onDismiss;

  const LocationPermissionDialog({
    super.key,
    required this.status,
    required this.onActionPressed,
    required this.onDismiss,
  });

  /// Show as bottom sheet
  static Future<void> show(
    BuildContext context, {
    required LocationStatus status,
    required VoidCallback onActionPressed,
    required VoidCallback onDismiss,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationPermissionDialog(
        status: status,
        onActionPressed: onActionPressed,
        onDismiss: onDismiss,
      ),
    );
  }

  IconData get _icon {
    switch (status) {
      case LocationStatus.granted:
        return Icons.check_circle;
      case LocationStatus.denied:
        return Icons.location_off;
      case LocationStatus.deniedForever:
        return Icons.app_settings_alt;
      case LocationStatus.serviceDisabled:
        return Icons.gps_off;
    }
  }

  Color get _iconColor {
    switch (status) {
      case LocationStatus.granted:
        return AppColors.success;
      case LocationStatus.denied:
        return AppColors.warning;
      case LocationStatus.deniedForever:
        return AppColors.error;
      case LocationStatus.serviceDisabled:
        return AppColors.error;
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon,
                size: 40,
                color: _iconColor,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              status.title,
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              status.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onActionPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  status.buttonText,
                  style: AppTextStyles.button,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Cancel Button
            if (status != LocationStatus.granted)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDismiss();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Daha Sonra',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

