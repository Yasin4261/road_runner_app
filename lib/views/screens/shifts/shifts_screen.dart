import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/data/models/shift.dart';
import 'package:road_runner_app/data/models/shift_template.dart';
import 'package:road_runner_app/viewmodels/shifts_viewmodel.dart';
import 'package:road_runner_app/views/screens/shifts/widgets/reserve_shift_sheet.dart';
import 'package:road_runner_app/views/screens/shifts/widgets/shift_action_dialog.dart';
import 'package:road_runner_app/views/screens/shifts/widgets/shift_card.dart';
import 'package:road_runner_app/views/screens/shifts/widgets/shift_template_card.dart';

/// Kurye vardiya yönetimi ana ekranı.
///
/// 3 sekme:
/// 1. Aktif    → mevcut aktif vardiya + check-out
/// 2. Gelecek  → rezerve edilmiş vardiyalar (check-in / iptal)
/// 3. Şablonlar → tüm vardiya şablonları (rezerve et)
class ShiftsScreen extends StatelessWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShiftsViewModel>(
      create: (_) => ShiftsViewModel.fromLocator()..loadAll(),
      child: const _ShiftsScreenContent(),
    );
  }
}

class _ShiftsScreenContent extends StatefulWidget {
  const _ShiftsScreenContent();

  @override
  State<_ShiftsScreenContent> createState() => _ShiftsScreenContentState();
}

class _ShiftsScreenContentState extends State<_ShiftsScreenContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? AppColors.error : AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vardiyalar'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(icon: Icon(Icons.play_circle_outline), text: 'Aktif'),
            Tab(icon: Icon(Icons.event_available_outlined), text: 'Gelecek'),
            Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Şablonlar'),
          ],
        ),
        actions: [
          Consumer<ShiftsViewModel>(
            builder: (_, vm, _) => IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: vm.isLoading ? null : vm.loadAll,
              tooltip: 'Yenile',
            ),
          ),
        ],
      ),
      body: Consumer<ShiftsViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.activeShift == null && vm.templates.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Column(
                children: [
                  if (vm.isError && vm.errorMessage.isNotEmpty)
                    _ErrorBanner(
                      message: vm.errorMessage,
                      onRetry: vm.loadAll,
                    ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _ActiveTab(vm: vm, onMessage: _showSnack),
                        _UpcomingTab(vm: vm, onMessage: _showSnack),
                        _TemplatesTab(vm: vm, onMessage: _showSnack),
                      ],
                    ),
                  ),
                ],
              ),
              if (vm.actionInProgress)
                Container(
                  color: Colors.black.withValues(alpha: 0.15),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Yükleme hatası için üst banner. Tıklayınca tam detay dialog'u açar.
class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.message, required this.onRetry});

  void _showDetails(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.bug_report_outlined,
            color: AppColors.error, size: 32),
        title: const Text('Hata Detayı'),
        content: SingleChildScrollView(
          child: SelectableText(
            message,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onRetry();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.error.withValues(alpha: 0.1),
      child: InkWell(
        onTap: () => _showDetails(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.error, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Veriler yüklenemedi (detay için dokunun)',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Tekrar'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================== AKTİF SEKME ===================

class _ActiveTab extends StatelessWidget {
  final ShiftsViewModel vm;
  final void Function(String, {bool error}) onMessage;

  const _ActiveTab({required this.vm, required this.onMessage});

  @override
  Widget build(BuildContext context) {
    final shift = vm.activeShift;
    return RefreshIndicator(
      onRefresh: vm.refreshActive,
      child: shift == null
          ? ListView(
              children: const [
                SizedBox(height: 80),
                _EmptyState(
                  icon: Icons.play_disabled,
                  title: 'Aktif vardiyanız yok',
                  description:
                      'Gelecek vardiyalarınıza giriş yaparak aktif hale getirebilirsiniz.',
                ),
              ],
            )
          : ListView(
              children: [
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _LiveBanner(),
                ),
                ShiftCard(
                  shift: shift,
                  accentColor: AppColors.success,
                  actions: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.warning,
                      ),
                      onPressed: () => _handleCheckOut(context),
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Çıkış Yap'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> _handleCheckOut(BuildContext context) async {
    final result = await ShiftActionDialog.checkOut(context);
    if (result == null) return;
    final ok = await vm.checkOut(notes: result['notes'] as String?);
    onMessage(
      ok ? 'Vardiyadan çıkış yapıldı' : vm.errorMessage,
      error: !ok,
    );
  }
}

class _LiveBanner extends StatelessWidget {
  const _LiveBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          _PulseDot(),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Şu anda aktif vardiyadasınız – sipariş ataması açık',
              style: TextStyle(
                  color: AppColors.success, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatelessWidget {
  const _PulseDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
    );
  }
}

// =================== GELECEK SEKME ===================

class _UpcomingTab extends StatelessWidget {
  final ShiftsViewModel vm;
  final void Function(String, {bool error}) onMessage;

  const _UpcomingTab({required this.vm, required this.onMessage});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: vm.refreshUpcoming,
      child: vm.upcomingShifts.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 80),
                _EmptyState(
                  icon: Icons.event_busy_outlined,
                  title: 'Gelecek vardiyanız yok',
                  description:
                      'Şablonlar sekmesinden yeni bir vardiya rezerve edebilirsiniz.',
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: vm.upcomingShifts.length,
              itemBuilder: (_, i) {
                final s = vm.upcomingShifts[i];
                return ShiftCard(
                  shift: s,
                  actions: _actionsFor(context, s),
                );
              },
            ),
    );
  }

  List<Widget> _actionsFor(BuildContext context, Shift s) {
    final actions = <Widget>[];
    if (s.canCancel) {
      actions.add(
        OutlinedButton.icon(
          onPressed: () => _handleCancel(context, s),
          icon: const Icon(Icons.close, size: 18),
          label: const Text('İptal'),
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
        ),
      );
    }
    if (s.canCheckIn) {
      actions.add(
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: AppColors.success),
          onPressed: () => _handleCheckIn(context, s),
          icon: const Icon(Icons.login, size: 18),
          label: const Text('Giriş Yap'),
        ),
      );
    }
    return actions;
  }

  Future<void> _handleCheckIn(BuildContext context, Shift s) async {
    final res = await ShiftActionDialog.checkIn(context);
    if (res == null) return;
    final ok = await vm.checkIn(s.shiftId, notes: res['notes'] as String?);
    onMessage(
      ok ? 'Vardiyaya giriş yapıldı' : vm.errorMessage,
      error: !ok,
    );
  }

  Future<void> _handleCancel(BuildContext context, Shift s) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rezervasyonu İptal Et'),
        content: Text('${s.dayLabel} • ${s.timeRange}\n'
            'Bu vardiya rezervasyonunu iptal etmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('İptal Et'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final ok = await vm.cancelShift(s.shiftId);
    onMessage(
      ok ? 'Rezervasyon iptal edildi' : vm.errorMessage,
      error: !ok,
    );
  }
}

// =================== ŞABLONLAR SEKME ===================

class _TemplatesTab extends StatelessWidget {
  final ShiftsViewModel vm;
  final void Function(String, {bool error}) onMessage;

  const _TemplatesTab({required this.vm, required this.onMessage});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: vm.loadAll,
      child: vm.templates.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 80),
                _EmptyState(
                  icon: Icons.calendar_today_outlined,
                  title: 'Vardiya şablonu yok',
                  description:
                      'Şu anda rezerve edilebilir bir şablon bulunmuyor.',
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: vm.templates.length,
              itemBuilder: (_, i) {
                final t = vm.templates[i];
                return ShiftTemplateCard(
                  template: t,
                  busy: vm.actionInProgress,
                  onReserve: () => _handleReserve(context, t),
                );
              },
            ),
    );
  }

  Future<void> _handleReserve(BuildContext context, ShiftTemplate t) async {
    final res = await ReserveShiftSheet.show(context, template: t);
    if (res == null) return;
    final ok = await vm.reserveShift(
      templateId: t.templateId,
      shiftDate: res['date'] as DateTime,
      notes: res['notes'] as String?,
    );
    onMessage(
      ok ? 'Vardiya başarıyla rezerve edildi' : vm.errorMessage,
      error: !ok,
    );
  }
}

// =================== ORTAK ===================

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Icon(icon, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

