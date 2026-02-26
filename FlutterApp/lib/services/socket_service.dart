import 'package:socket_io_client/socket_io_client.dart' as io;
import '../config/api_config.dart';

class SocketService {
  static io.Socket? _socket;

  static io.Socket get socket {
    _socket ??= io.io(
      ApiConfig.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .build(),
    );
    return _socket!;
  }

  static void connect() {
    socket.connect();
  }

  static void disconnect() {
    socket.disconnect();
  }

  static void sendMessage(Map<String, dynamic> payload) {
    socket.emit('send_message', payload);
  }

  static void onReceiveMessage(void Function(dynamic) callback) {
    socket.on('receive_message', callback);
  }

  static void offReceiveMessage() {
    socket.off('receive_message');
  }
}
