class ApiConstants {
  ApiConstants._();

  // Base URL - Change this to your API base URL
  static const String baseUrl = 'https://api.example.com';

  // API Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String users = '/users';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}

