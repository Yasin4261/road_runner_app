import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;

  void initializeSocket() {
    _socket = IO.io('http://0.0.0.0:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      print('Connected to socket server');
    });

    _socket.on('disconnect', (_) {
      print('Disconnected from socket server');
    });

    _socket.on('orderNotification', (data) {
      print('Order Notification received: $data');
      // Handle the order notification data
    });

    _socket.connect();
  }

  void dispose() {
    _socket.dispose();
  }
}
