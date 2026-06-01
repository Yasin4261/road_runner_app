import 'package:flutter/material.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';

/// Check-in / Check-out işlemleri için ortak onay dialog'u.
/// Onaylanırsa { 'notes': String? } pop eder, iptalde null.
class ShiftActionDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final IconData icon;
  final Color color;
  final bool showLocationHint;

  const ShiftActionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.icon,
    required this.color,
    this.showLocationHint = true,
  });

  static Future<Map<String, dynamic>?> checkIn(BuildContext context) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const ShiftActionDialog(
        title: 'Vardiyaya Giriş',
        message:
            'Vardiyaya giriş yapmak istediğinize emin misiniz?\nKonum bilginiz işverene iletilecek.',
        confirmLabel: 'Giriş Yap',
        icon: Icons.login,
        color: AppColors.success,
      ),
    );
  }

  static Future<Map<String, dynamic>?> checkOut(BuildContext context) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const ShiftActionDialog(
        title: 'Vardiyadan Çıkış',
        message: 'Vardiyanızı sonlandırmak istediğinize emin misiniz?',
        confirmLabel: 'Çıkış Yap',
        icon: Icons.logout,
        color: AppColors.warning,
      ),
    );
  }

  @override
  State<ShiftActionDialog> createState() => _ShiftActionDialogState();
}

class _ShiftActionDialogState extends State<ShiftActionDialog> {
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: CircleAvatar(
        radius: 28,
        backgroundColor: widget.color.withValues(alpha: 0.15),
        child: Icon(widget.icon, color: widget.color, size: 28),
      ),
      title: Text(widget.title, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Not ekle (opsiyonel)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              isDense: true,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Vazgeç'),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: widget.color),
          onPressed: () {
            Navigator.of(context).pop({
              'notes': _notesCtrl.text.trim().isEmpty
                  ? null
                  : _notesCtrl.text.trim(),
            });
          },
          icon: Icon(widget.icon, size: 18),
          label: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

