import 'package:flutter/material.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/core/utils/date_formatter.dart';
import 'package:road_runner_app/data/models/shift.dart';

/// Aktif vardiya, gelecek vardiya ve geçmiş vardiya için kullanılan kart.
class ShiftCard extends StatelessWidget {
  final Shift shift;
  final List<Widget> actions;
  final Color? accentColor;
  final String? statusLabelOverride;

  const ShiftCard({
    super.key,
    required this.shift,
    this.actions = const [],
    this.accentColor,
    this.statusLabelOverride,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? _colorForStatus(shift);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.schedule, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shift.dayLabel,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(shift.timeRange,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                _StatusChip(
                  label: statusLabelOverride ?? shift.status.displayLabel,
                  color: accent,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.timer_outlined,
              label: 'Süre',
              value: '${shift.duration.inHours} sa '
                  '${shift.duration.inMinutes.remainder(60)} dk',
            ),
            if (shift.shiftRole != null)
              _InfoRow(
                icon: Icons.badge_outlined,
                label: 'Rol',
                value: shift.shiftRole!.displayLabel,
              ),
            if (shift.checkInTime != null)
              _InfoRow(
                icon: Icons.login,
                label: 'Giriş',
                value:
                    '${DateFormatter.shortDate(shift.checkInTime!.toLocal())} '
                    '${DateFormatter.hm(shift.checkInTime!.toLocal())}',
              ),
            if (shift.notes != null && shift.notes!.isNotEmpty)
              _InfoRow(
                icon: Icons.notes,
                label: 'Not',
                value: shift.notes!,
              ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions
                    .expand((w) => [w, const SizedBox(width: 8)])
                    .toList()
                  ..removeLast(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _colorForStatus(Shift s) {
    return switch (s.status) {
      _ when s.isActive => AppColors.success,
      _ => AppColors.primary,
    };
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

