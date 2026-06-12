import 'package:flutter/foundation.dart';
import 'package:road_runner_app/core/di/service_locator.dart';
import 'package:road_runner_app/data/models/shift.dart';
import 'package:road_runner_app/data/models/shift_template.dart';
import 'package:road_runner_app/data/services/location_service.dart';
import 'package:road_runner_app/data/services/shift_service.dart';
import 'package:road_runner_app/viewmodels/base_viewmodel.dart';

/// Kurye Vardiya ekranlarının state'ini yöneten ViewModel.
class ShiftsViewModel extends BaseViewModel {
  final ShiftService _shiftService;
  final LocationService _locationService;

  ShiftsViewModel({
    required ShiftService shiftService,
    required LocationService locationService,
  })  : _shiftService = shiftService,
        _locationService = locationService;

  factory ShiftsViewModel.fromLocator() => ShiftsViewModel(
        shiftService: locator<ShiftService>(),
        locationService: locator<LocationService>(),
      );

  // ---------- State ----------
  Shift? _activeShift;
  List<Shift> _upcomingShifts = const [];
  List<ShiftTemplate> _templates = const [];
  bool _actionInProgress = false;

  Shift? get activeShift => _activeShift;
  List<Shift> get upcomingShifts => _upcomingShifts;
  List<ShiftTemplate> get templates => _templates;
  bool get actionInProgress => _actionInProgress;

  void _setActionInProgress(bool value) {
    _actionInProgress = value;
    notifyListeners();
  }

  // ---------- Load ----------

  /// Tüm vardiya verilerini bağımsız olarak yükler.
  /// Bir endpoint hata verse bile diğerleri yüklenmeye devam eder.
  Future<void> loadAll() async {
    setLoading();

    final errors = <String>[];

    // Templates
    try {
      _templates = await _shiftService.getTemplates();
      debugPrint('[ShiftsVM] templates loaded: ${_templates.length}');
    } catch (e) {
      final msg = ShiftService.extractError(e);
      debugPrint('[ShiftsVM] templates ERROR: $msg');
      errors.add('Şablonlar: $msg');
      _templates = const [];
    }

    // Upcoming
    try {
      _upcomingShifts = await _shiftService.getUpcomingShifts();
      debugPrint('[ShiftsVM] upcoming loaded: ${_upcomingShifts.length}');
    } catch (e) {
      final msg = ShiftService.extractError(e);
      debugPrint('[ShiftsVM] upcoming ERROR: $msg');
      errors.add('Gelecek vardiyalar: $msg');
      _upcomingShifts = const [];
    }

    // Active
    try {
      _activeShift = await _shiftService.getActiveShift();
      debugPrint('[ShiftsVM] active loaded: ${_activeShift?.shiftId}');
    } catch (e) {
      final msg = ShiftService.extractError(e);
      debugPrint('[ShiftsVM] active ERROR: $msg');
      errors.add('Aktif vardiya: $msg');
      _activeShift = null;
    }

    if (errors.isNotEmpty) {
      // En az bir endpoint başarısız → kullanıcıya göster, ama elde edilen veriyi koru
      setError(errors.join('\n'));
    } else {
      setSuccess();
    }
  }

  Future<void> refreshActive() async {
    try {
      _activeShift = await _shiftService.getActiveShift();
      notifyListeners();
    } catch (e) {
      debugPrint('[ShiftsVM] refreshActive error: $e');
    }
  }

  Future<void> refreshUpcoming() async {
    try {
      _upcomingShifts = await _shiftService.getUpcomingShifts();
      notifyListeners();
    } catch (e) {
      debugPrint('[ShiftsVM] refreshUpcoming error: $e');
    }
  }

  // ---------- Actions ----------

  /// Vardiya rezerve et. Başarılıysa true döner.
  Future<bool> reserveShift({
    required int templateId,
    required DateTime shiftDate,
    String? notes,
  }) async {
    _setActionInProgress(true);
    try {
      final shift = await _shiftService.reserveShift(
        templateId: templateId,
        shiftDate: shiftDate,
        notes: notes,
      );
      _upcomingShifts = [..._upcomingShifts, shift]
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      notifyListeners();
      return true;
    } catch (e) {
      setError(ShiftService.extractError(e));
      return false;
    } finally {
      _setActionInProgress(false);
    }
  }

  /// Vardiyaya giriş yap. Konum opsiyonel ama gönderilmesi tavsiye edilir.
  Future<bool> checkIn(int shiftId, {String? notes, bool sendLocation = true}) async {
    _setActionInProgress(true);
    try {
      double? lat;
      double? lng;
      if (sendLocation) {
        final pos = await _safeGetLocation();
        lat = pos?.$1;
        lng = pos?.$2;
      }

      final shift = await _shiftService.checkIn(
        shiftId,
        notes: notes,
        latitude: lat,
        longitude: lng,
      );
      _activeShift = shift;
      _upcomingShifts = _upcomingShifts
          .where((s) => s.shiftId != shift.shiftId)
          .toList();
      notifyListeners();
      return true;
    } catch (e) {
      setError(ShiftService.extractError(e));
      return false;
    } finally {
      _setActionInProgress(false);
    }
  }

  Future<bool> checkOut({String? notes, bool sendLocation = true}) async {
    final active = _activeShift;
    if (active == null) {
      setError('Aktif vardiyanız yok');
      return false;
    }
    _setActionInProgress(true);
    try {
      double? lat;
      double? lng;
      if (sendLocation) {
        final pos = await _safeGetLocation();
        lat = pos?.$1;
        lng = pos?.$2;
      }
      await _shiftService.checkOut(
        active.shiftId,
        notes: notes,
        latitude: lat,
        longitude: lng,
      );
      _activeShift = null;
      notifyListeners();
      return true;
    } catch (e) {
      setError(ShiftService.extractError(e));
      return false;
    } finally {
      _setActionInProgress(false);
    }
  }

  Future<bool> cancelShift(int shiftId) async {
    _setActionInProgress(true);
    try {
      await _shiftService.cancelShift(shiftId);
      _upcomingShifts =
          _upcomingShifts.where((s) => s.shiftId != shiftId).toList();
      notifyListeners();
      return true;
    } catch (e) {
      setError(ShiftService.extractError(e));
      return false;
    } finally {
      _setActionInProgress(false);
    }
  }

  // ---------- Helpers ----------

  /// Konumu güvenli şekilde al (izin yoksa null döner).
  Future<(double, double)?> _safeGetLocation() async {
    try {
      final pos = await _locationService.getCurrentPosition();
      if (pos == null) return null;
      return (pos.latitude, pos.longitude);
    } catch (e) {
      debugPrint('[ShiftsVM] Konum alınamadı: $e');
      return null;
    }
  }
}


