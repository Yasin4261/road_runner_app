import 'package:flutter/material.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/data/models/assignment_notification.dart';

/// Yeni sipariş geldiğinde ekranın neresinde olursa olsun gösterilen
/// dikkat çekici bildirim dialog'u. Kabul / Reddet döndürür.
enum AssignmentDecision { accept, reject, dismiss }

class NewAssignmentDialog extends StatelessWidget {
  final AssignmentNotification assignment;

  const NewAssignmentDialog({super.key, required this.assignment});

  static Future<AssignmentDecision?> show(
    BuildContext context,
    AssignmentNotification assignment,
  ) {
    return showDialog<AssignmentDecision>(
      context: context,
      barrierDismissible: false,
      builder: (_) => NewAssignmentDialog(assignment: assignment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = assignment.orderDetails;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Başlık - animasyonlu his veren üst bant
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Column(
              children: [
                Icon(Icons.notifications_active,
                    color: Colors.white, size: 36),
                SizedBox(height: 6),
                Text(
                  'Yeni Sipariş!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sipariş #${assignment.orderId}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                if (details?.endCustomerName != null)
                  _row(Icons.person, details!.endCustomerName!),
                if (details?.packageDescription != null)
                  _row(Icons.inventory_2, details!.packageDescription!),
                if (details?.pickupAddress != null)
                  _row(Icons.store, details!.pickupAddress!,
                      color: Colors.blue),
                if (details?.deliveryAddress != null)
                  _row(Icons.location_on, details!.deliveryAddress!,
                      color: Colors.red),
                if (details?.deliveryFee != null)
                  _row(Icons.payments,
                      '₺${details!.deliveryFee!.toStringAsFixed(2)} teslimat ücreti',
                      color: AppColors.success),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(
                            context, AssignmentDecision.reject),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Reddet'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.pop(
                            context, AssignmentDecision.accept),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Kabul Et'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

