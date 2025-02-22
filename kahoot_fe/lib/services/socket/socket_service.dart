import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:kahoot_clone/common/constants.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket _socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  IO.Socket get socket => _socket;

  Future<void> connect() async {
    _socket = IO.io(
      Constants.WS_URL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setReconnectionAttempts(5) 
          .setReconnectionDelay(3000)
          .build(),
    );

    _socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });
  }

  void emitEvent(String event, Map<String, dynamic> data) {
    _socket.emit(event, data);
  }

  void dispose() {
    _socket.dispose();
  }
}
