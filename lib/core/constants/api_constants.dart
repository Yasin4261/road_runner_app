class ApiConstants {
  ApiConstants._();
  // Base URL - Change this to your API base URL
  static const String baseUrl = 'http://192.168.1.109:8081';
  // WebSocket
  static const String wsUrl = 'ws://192.168.1.109:8081/ws';
  // API Endpoints
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String users = '/users';
  // Courier Assignment Endpoints
  static const String pendingAssignments = '/api/v1/courier/assignments/pending';
  static const String acceptAssignment = '/api/v1/courier/assignments'; // /{id}/accept
  static const String rejectAssignment = '/api/v1/courier/assignments'; // /{id}/reject
  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
