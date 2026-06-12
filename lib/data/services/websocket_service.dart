import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:road_runner_app/core/constants/api_constants.dart';
import 'package:road_runner_app/data/models/assignment_notification.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

/// STOMP WebSocket servisi — backend ile gerçek zamanlı iletişim sağlar.
///
/// Kurye JWT token'ı ile bağlanır ve `/user/queue/assignments` topic'ine
/// subscribe olarak yeni sipariş atamalarını dinler.
class WebSocketService {
  StompClient? _client;
  bool _isConnected = false;

  final _assignmentController = StreamController<AssignmentNotification>.broadcast();

  /// Yeni atama notification'larını dinlemek için stream
  Stream<AssignmentNotification> get assignmentStream => _assignmentController.stream;

  bool get isConnected => _isConnected;

  /// JWT token ile WebSocket bağlantısı kur
  void connect(String jwtToken) {
    if (_isConnected) {
      debugPrint('[WS] Already connected, skipping');
      return;
    }

    

    _client = StompClient(
      config: StompConfig(
        url: ApiConstants.wsUrl, // Raw WebSocket endpoint (SockJS değil)
        stompConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        onConnect: _onConnect,
        onDisconnect: _onDisconnect,
        onWebSocketError: (error) {
          debugPrint('[WS] WebSocket error: $error');
        },
        onStompError: (frame) {
          debugPrint('[WS] STOMP error: ${frame.body}');
        },
        // Otomatik yeniden bağlanma
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    debugPrint('[WS] Connecting to ${ApiConstants.wsUrl}...');
    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    _isConnected = true;
    debugPrint('[WS] Connected successfully');

    // Kurye'nin kişisel assignment kanalına subscribe ol
    // Backend convertAndSendToUser(userId, "/queue/assignments", ...) ile gönderir
    // Spring bunu /user/{userId}/queue/assignments'a çevirir
    // Client tarafında sadece /user/queue/assignments'a subscribe olmak yeterli
    _client!.subscribe(
      destination: '/user/queue/assignments',
      callback: _onAssignmentReceived,
    );

    debugPrint('[WS] Subscribed to /user/queue/assignments');
  }

  void _onAssignmentReceived(StompFrame frame) {
    if (frame.body == null) return;

    debugPrint('[WS] Received assignment: ${frame.body}');

    try {
      final json = jsonDecode(frame.body!) as Map<String, dynamic>;
      final notification = AssignmentNotification.fromJson(json);
      _assignmentController.add(notification);

      debugPrint('[WS] Assignment notification: type=${notification.type}, '
          'assignmentId=${notification.assignmentId}, orderId=${notification.orderId}');
    } catch (e) {
      debugPrint('[WS] Failed to parse assignment: $e');
    }
  }

  void _onDisconnect(StompFrame frame) {
    _isConnected = false;
    debugPrint('[WS] Disconnected');
  }

  /// Bağlantıyı kapat
  void disconnect() {
    _client?.deactivate();
    _isConnected = false;
    
    debugPrint('[WS] Disconnected manually');
  }

  /// Servisi temizle
  void dispose() {
    disconnect();
    _assignmentController.close();
  }
}

