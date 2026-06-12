class ApiConstants {
  ApiConstants._();
  // Base URL - Change this to your API base URL
  //
  // Fiziksel cihaz (USB/adb reverse) için: http://127.0.0.1:8081
  //   → Terminalde bir kez: `adb reverse tcp:8081 tcp:8081`
  //   → Firewall/WiFi sorunlarını tamamen atlar (USB üzerinden tünel).
  // Aynı WiFi'daki gerçek cihaz için: http://192.168.1.109:8081
  // Android emülatör için:            http://10.0.2.2:8081
  static const String baseUrl = 'http://127.0.0.1:8081';
  // WebSocket
  static const String wsUrl = 'ws://127.0.0.1:8081/ws';
  // API Endpoints
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String users = '/users';
  // Courier Assignment Endpoints
  static const String pendingAssignments = '/api/v1/courier/assignments/pending';
  static const String acceptAssignment = '/api/v1/courier/assignments'; // /{id}/accept
  static const String rejectAssignment = '/api/v1/courier/assignments'; // /{id}/reject

  // Courier Order Endpoints
  // GET base?status=...  → kuryenin siparişleri (aktif/geçmiş)
  // /{id}, /{id}/pickup, /{id}/start-delivery, /{id}/complete
  static const String courierOrders = '/api/v1/courier/orders';

  // ===== Courier Shift Endpoints =====
  // Base: /api/v1/courier/shifts
  static const String shiftsBase = '/api/v1/courier/shifts';
  static const String shiftTemplates = '$shiftsBase/templates';
  static const String shiftReserve = '$shiftsBase/reserve';
  static const String shiftUpcoming = '$shiftsBase/upcoming';
  static const String shiftMine = '$shiftsBase/my-shifts'; // ?status=...
  static const String shiftActive = '$shiftsBase/active';
  static String shiftCheckIn(int shiftId) => '$shiftsBase/$shiftId/check-in';
  static String shiftCheckOut(int shiftId) => '$shiftsBase/$shiftId/check-out';
  static String shiftCancel(int shiftId) => '$shiftsBase/$shiftId/cancel';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
