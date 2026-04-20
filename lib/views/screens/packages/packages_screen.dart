import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_runner_app/data/models/assignment_notification.dart';
import 'package:road_runner_app/viewmodels/assignment_viewmodel.dart';
class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssignmentViewModel.fromLocator(),
      child: const _PackagesView(),
    );
  }
}
class _PackagesView extends StatelessWidget {
  const _PackagesView();
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AssignmentViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paketlerim'),
        centerTitle: true,
        actions: [
          // Bağlantı durumu göstergesi
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.circle,
              size: 12,
              color: viewModel.isConnected ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      body: viewModel.pendingAssignments.isEmpty
          ? const _EmptyState()
          : _AssignmentList(assignments: viewModel.pendingAssignments),
    );
  }
}
class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delivery_dining, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Bekleyen atama yok',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Yeni sipariş geldiğinde burada görünecek',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
class _AssignmentList extends StatelessWidget {
  final List<AssignmentNotification> assignments;
  const _AssignmentList({required this.assignments});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        return _AssignmentCard(assignment: assignments[index]);
      },
    );
  }
}
class _AssignmentCard extends StatelessWidget {
  final AssignmentNotification assignment;
  const _AssignmentCard({required this.assignment});
  @override
  Widget build(BuildContext context) {
    final details = assignment.orderDetails;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sipariş #${assignment.orderId}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Bekliyor',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Müşteri
            if (details?.endCustomerName != null)
              _InfoRow(
                icon: Icons.person,
                label: details!.endCustomerName!,
              ),
            // Paket
            if (details?.packageDescription != null)
              _InfoRow(
                icon: Icons.inventory_2,
                label: details!.packageDescription!,
              ),
            // Alış adresi
            if (details?.pickupAddress != null)
              _InfoRow(
                icon: Icons.store,
                label: details!.pickupAddress!,
                iconColor: Colors.blue,
              ),
            // Teslimat adresi
            if (details?.deliveryAddress != null)
              _InfoRow(
                icon: Icons.location_on,
                label: details!.deliveryAddress!,
                iconColor: Colors.red,
              ),
            // Ücret
            if (details?.deliveryFee != null)
              _InfoRow(
                icon: Icons.payments,
                label: '₺${details!.deliveryFee!.toStringAsFixed(2)}',
                iconColor: Colors.green,
              ),
            const SizedBox(height: 16),
            // Aksiyon butonları
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context
                          .read<AssignmentViewModel>()
                          .removeAssignment(assignment.assignmentId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Atama reddedildi')),
                      );
                    },
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reddet'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      context
                          .read<AssignmentViewModel>()
                          .removeAssignment(assignment.assignmentId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Atama kabul edildi!')),
                      );
                    },
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Kabul Et'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  const _InfoRow({
    required this.icon,
    required this.label,
    this.iconColor,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor ?? Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
