import 'package:flutter/material.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/core/utils/date_formatter.dart';
import 'package:road_runner_app/data/models/shift_template.dart';

/// Vardiya rezervasyonu için tarih + not bottom sheet.
/// Onaylanırsa { 'date': DateTime, 'notes': String? } map'i ile pop eder.
class ReserveShiftSheet extends StatefulWidget {
  final ShiftTemplate template;

  const ReserveShiftSheet({super.key, required this.template});

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required ShiftTemplate template,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ReserveShiftSheet(template: template),
    );
  }

  @override
  State<ReserveShiftSheet> createState() => _ReserveShiftSheetState();
}

class _ReserveShiftSheetState extends State<ReserveShiftSheet> {
  DateTime _date = DateTime.now();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Şu anki saatten sonra başlayan vardiya bugün değilse yarına ayarla
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 60)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.template;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Vardiya Rezervasyonu',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('${t.name}  •  ${t.timeRange}',
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 20),

              // Tarih seçici
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vardiya tarihi',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text(DateFormatter.dayLabel(_date),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notlar
              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Notlar (opsiyonel)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop({
                      'date': _date,
                      'notes': _notesCtrl.text.trim().isEmpty
                          ? null
                          : _notesCtrl.text.trim(),
                    });
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Rezervasyonu Onayla'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

