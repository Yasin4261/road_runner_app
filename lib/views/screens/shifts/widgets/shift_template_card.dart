import 'package:flutter/material.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/data/models/shift_template.dart';

/// Vardiya şablonu kartı - Rezerve Et butonu içerir.
class ShiftTemplateCard extends StatelessWidget {
  final ShiftTemplate template;
  final VoidCallback onReserve;
  final bool busy;

  const ShiftTemplateCard({
    super.key,
    required this.template,
    required this.onReserve,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.access_time_filled,
                  color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(template.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(template.timeRange,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                  if (template.description != null &&
                      template.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(template.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textHint)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: busy ? null : onReserve,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Rezerve'),
            ),
          ],
        ),
      ),
    );
  }
}

