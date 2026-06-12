import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:road_runner_app/core/enums/order_status.dart';
import 'package:road_runner_app/core/theme/app_colors.dart';
import 'package:road_runner_app/data/models/courier_order.dart';
import 'package:road_runner_app/data/services/location_service.dart';
import 'package:road_runner_app/viewmodels/active_delivery_viewmodel.dart';
import 'package:road_runner_app/views/widgets/map/map_provider.dart';
import 'package:road_runner_app/views/widgets/map/map_provider_factory.dart';
import 'package:road_runner_app/views/widgets/map/map_types.dart';

/// Kabul edilen siparişin teslimat akışını yöneten ekran.
/// Üstte harita (restoran + müşteri + kurye konumu), altta adım adım butonlar.
class ActiveDeliveryScreen extends StatefulWidget {
  const ActiveDeliveryScreen({super.key});

  @override
  State<ActiveDeliveryScreen> createState() => _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends State<ActiveDeliveryScreen> {
  late final MapProvider _mapProvider;
  MapPosition? _userLocation;

  @override
  void initState() {
    super.initState();
    _mapProvider = MapProviderFactory.create(
      MapProviderType.openStreetMap,
      initialPosition: MapPosition.kadikoy,
    );
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    final pos = await LocationService.instance.getCurrentPosition();
    if (pos != null && mounted) {
      setState(() => _userLocation = pos);
    }
    // Haritayı aktif hedefe odakla
    _focusOnActiveTarget();
  }

  void _focusOnActiveTarget() {
    final order = context.read<ActiveDeliveryViewModel>().order;
    if (order == null) return;
    // PICKED_UP veya IN_TRANSIT ise müşteriye, değilse restorana odaklan
    final goToCustomer = order.status == OrderStatus.pickedUp ||
        order.status == OrderStatus.inTransit;
    final lat = goToCustomer ? order.deliveryLatitude : order.pickupLatitude;
    final lng = goToCustomer ? order.deliveryLongitude : order.pickupLongitude;
    if (lat != null && lng != null) {
      _mapProvider.moveToPosition(
          MapPosition(latitude: lat, longitude: lng, zoom: 15));
    }
  }

  @override
  void dispose() {
    _mapProvider.dispose();
    super.dispose();
  }

  List<MapMarker> _buildMarkers(CourierOrder order) {
    final markers = <MapMarker>[];
    if (order.hasPickupLocation) {
      markers.add(MapMarker(
        latitude: order.pickupLatitude!,
        longitude: order.pickupLongitude!,
        type: MapMarkerType.pickup,
        label: order.businessName ?? 'Restoran',
      ));
    }
    if (order.hasDeliveryLocation) {
      markers.add(MapMarker(
        latitude: order.deliveryLatitude!,
        longitude: order.deliveryLongitude!,
        type: MapMarkerType.delivery,
        label: order.endCustomerName ?? 'Müşteri',
      ));
    }
    return markers;
  }

  /// Harici harita uygulamasında yol tarifi aç
  Future<void> _openDirections(double lat, double lng) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harita uygulaması açılamadı')),
      );
    }
  }

  void _showSnack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktif Teslimat'),
        centerTitle: true,
      ),
      body: Consumer<ActiveDeliveryViewModel>(
        builder: (context, vm, _) {
          final order = vm.order;
          if (order == null) {
            return const Center(child: Text('Aktif teslimat yok'));
          }

          return Stack(
            children: [
              Column(
                children: [
                  // Harita
                  Expanded(
                    flex: 3,
                    child: _mapProvider.buildMap(
                      position: MapPosition.kadikoy,
                      onPositionChanged: (_) {},
                      userLocation: _userLocation,
                      markers: _buildMarkers(order),
                    ),
                  ),
                  // Sipariş detay + aksiyon paneli
                  Expanded(
                    flex: 2,
                    child: _DeliveryPanel(
                      order: order,
                      onOpenDirections: _openDirections,
                      onMessage: _showSnack,
                    ),
                  ),
                ],
              ),
              if (vm.actionInProgress)
                Container(
                  color: Colors.black.withValues(alpha: 0.2),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Alt panel: sipariş bilgisi + duruma göre adım butonu
class _DeliveryPanel extends StatelessWidget {
  final CourierOrder order;
  final void Function(double lat, double lng) onOpenDirections;
  final void Function(String, {bool error}) onMessage;

  const _DeliveryPanel({
    required this.order,
    required this.onOpenDirections,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Durum adımları göstergesi
            _StatusStepper(status: order.status),
            const SizedBox(height: 12),

            Row(
              children: [
                Text('Sipariş #${order.id}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(order.status.displayLabel,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                ),
              ],
            ),
            const Divider(height: 20),

            // Aktif hedef (duruma göre restoran veya müşteri)
            _targetSection(context),

            const SizedBox(height: 12),
            if (order.packageDescription != null)
              _infoLine(Icons.inventory_2, order.packageDescription!),
            _infoLine(Icons.payments,
                '₺${order.deliveryFee?.toStringAsFixed(2) ?? "-"} teslimat • '
                '${order.paymentLabel}'
                '${(order.collectionAmount ?? 0) > 0 ? " • ₺${order.collectionAmount!.toStringAsFixed(2)} tahsilat" : ""}'),

            const SizedBox(height: 16),
            _actionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _targetSection(BuildContext context) {
    final goToCustomer = order.status == OrderStatus.pickedUp ||
        order.status == OrderStatus.inTransit;
    final title = goToCustomer ? 'Teslimat Adresi' : 'Alış Adresi (Restoran)';
    final name = goToCustomer
        ? (order.endCustomerName ?? 'Müşteri')
        : (order.businessName ?? 'Restoran');
    final address =
        goToCustomer ? order.deliveryAddress : order.pickupAddress;
    final phone =
        goToCustomer ? order.endCustomerPhone : order.businessPhone;
    final lat = goToCustomer ? order.deliveryLatitude : order.pickupLatitude;
    final lng = goToCustomer ? order.deliveryLongitude : order.pickupLongitude;
    final color = goToCustomer ? Colors.red : Colors.blue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(goToCustomer ? Icons.location_on : Icons.store,
                color: color, size: 20),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(address,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Row(
          children: [
            if (lat != null && lng != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onOpenDirections(lat, lng),
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Yol Tarifi'),
                ),
              ),
            if (phone != null) ...[
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _callPhone(context, phone),
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('Ara'),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _callPhone(BuildContext context, String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _infoLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  /// Duruma göre ana aksiyon butonu
  Widget _actionButton(BuildContext context) {
    final vm = context.read<ActiveDeliveryViewModel>();

    switch (order.status) {
      case OrderStatus.assigned:
        return _bigButton(
          label: 'Siparişi Teslim Aldım',
          icon: Icons.shopping_bag,
          color: AppColors.info,
          onPressed: () async {
            final ok = await vm.pickup();
            onMessage(ok ? 'Sipariş teslim alındı' : vm.errorMessage,
                error: !ok);
          },
        );
      case OrderStatus.pickedUp:
        return _bigButton(
          label: 'Teslimata Başla (Yola Çık)',
          icon: Icons.directions_bike,
          color: AppColors.warning,
          onPressed: () async {
            final ok = await vm.startDelivery();
            onMessage(ok ? 'Teslimat başladı' : vm.errorMessage, error: !ok);
          },
        );
      case OrderStatus.inTransit:
        return _bigButton(
          label: 'Teslim Ettim',
          icon: Icons.check_circle,
          color: AppColors.success,
          onPressed: () => _confirmComplete(context, vm),
        );
      case OrderStatus.delivered:
        return _bigButton(
          label: 'Teslim Edildi ✓',
          icon: Icons.done_all,
          color: AppColors.success,
          onPressed: () {
            vm.clear();
            Navigator.of(context).maybePop();
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _confirmComplete(
      BuildContext context, ActiveDeliveryViewModel vm) async {
    final notesCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Teslimatı Tamamla'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                '${order.endCustomerName ?? "Müşteri"} adresine teslim ettiğinizi onaylıyor musunuz?'),
            const SizedBox(height: 12),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(
                hintText: 'Teslimat notu (opsiyonel)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Teslim Ettim'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await vm.complete(
      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
    );
    onMessage(ok ? 'Sipariş başarıyla teslim edildi 🎉' : vm.errorMessage,
        error: !ok);
  }

  Widget _bigButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

/// Teslimat aşama göstergesi (4 adım)
class _StatusStepper extends StatelessWidget {
  final OrderStatus status;
  const _StatusStepper({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Atandı', OrderStatus.assigned),
      ('Alındı', OrderStatus.pickedUp),
      ('Yolda', OrderStatus.inTransit),
      ('Teslim', OrderStatus.delivered),
    ];
    final currentIndex = _indexFor(status);

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final lineIndex = (i - 1) ~/ 2;
          return Expanded(
            child: Container(
              height: 3,
              color: lineIndex < currentIndex
                  ? AppColors.success
                  : AppColors.divider,
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final done = stepIndex <= currentIndex;
        return Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor:
                  done ? AppColors.success : AppColors.divider,
              child: done
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Text('${stepIndex + 1}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
            ),
            const SizedBox(height: 2),
            Text(steps[stepIndex].$1,
                style: const TextStyle(fontSize: 10)),
          ],
        );
      }),
    );
  }

  int _indexFor(OrderStatus s) {
    switch (s) {
      case OrderStatus.assigned:
        return 0;
      case OrderStatus.pickedUp:
        return 1;
      case OrderStatus.inTransit:
        return 2;
      case OrderStatus.delivered:
        return 3;
      default:
        return 0;
    }
  }
}

