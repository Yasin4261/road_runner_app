import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/core/enums/order_status.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/core/utils/date_formatter.dart';
import 'package:road_runner_app/data/models/courier_order.dart';
import 'package:road_runner_app/viewmodels/active_delivery_viewmodel.dart';
import 'package:road_runner_app/viewmodels/order_history_viewmodel.dart';
import 'package:road_runner_app/views/screens/delivery/active_delivery_screen.dart';
/// Paketlerim - aktif teslimat kısayolu + sipariş geçmişi
class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderHistoryViewModel.fromLocator()..load(),
      child: const _PackagesView(),
    );
  }
}
class _PackagesView extends StatelessWidget {
  const _PackagesView();
  @override
  Widget build(BuildContext context) {
    final history = context.watch<OrderHistoryViewModel>();
    final active = context.watch<ActiveDeliveryViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paketlerim'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: history.isLoading ? null : history.load,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: history.refresh,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // Aktif teslimat kartı
            if (active.hasActiveOrder && active.order != null)
              _ActiveDeliveryCard(order: active.order!),
            // Geçmiş başlığı
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Geçmiş Siparişler',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            if (history.isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (history.isError)
              _ErrorBox(message: history.errorMessage, onRetry: history.load)
            else if (history.orders.isEmpty)
              const _EmptyState()
            else
              ...history.orders.map((o) => _HistoryCard(order: o)),
          ],
        ),
      ),
    );
  }
}
class _ActiveDeliveryCard extends StatelessWidget {
  final CourierOrder order;
  const _ActiveDeliveryCard({required this.order});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      color: AppColors.primary.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.primary, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.local_shipping, color: Colors.white),
        ),
        title: Text('Aktif Teslimat • #${order.id}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            '${order.status.displayLabel} → ${order.endCustomerName ?? "Müşteri"}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          final active = context.read<ActiveDeliveryViewModel>();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: active,
              child: const ActiveDeliveryScreen(),
            ),
          ));
        },
      ),
    );
  }
}
class _HistoryCard extends StatelessWidget {
  final CourierOrder order;
  const _HistoryCard({required this.order});
  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('#${order.id} • ${order.orderNumber}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(order.status.displayLabel,
                      style: TextStyle(
                          color: _statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _line(Icons.person, order.endCustomerName ?? '-'),
            _line(Icons.location_on, order.deliveryAddress),
            Row(
              children: [
                Icon(Icons.payments, size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('₺${order.deliveryFee?.toStringAsFixed(2) ?? "-"}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const Spacer(),
                if (order.updatedAt != null)
                  Text(
                    '${DateFormatter.shortDate(order.updatedAt!.toLocal())} '
                    '${DateFormatter.hm(order.updatedAt!.toLocal())}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _line(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.history, size: 64, color: AppColors.textHint),
          SizedBox(height: 12),
          Text('Henüz tamamlanmış sipariş yok',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBox({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 40),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}
