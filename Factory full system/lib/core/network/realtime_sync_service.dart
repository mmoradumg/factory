import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

final class RealtimeSyncService {
  final Uri _url;

  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  bool _isDisposed = false;
  bool _isConnecting = false;
  Timer? _reconnectTimer;

  RealtimeSyncService(this._url);

  Stream<Map<String, dynamic>> get syncStream => _controller.stream;

  void connect(String token) {
    if (_isDisposed || _isConnecting) return;

    _isConnecting = true;

    try {
      _channel?.sink.close();

      _channel = WebSocketChannel.connect(
        _url.replace(queryParameters: {'token': token}),
      );

      _channel!.stream.listen(
        (data) {
          try {
            final decoded = jsonDecode(data);
            if (decoded is Map<String, dynamic>) {
              _controller.add(decoded);
            }
          } catch (_) {
            // Ignore malformed messages
          }
        },
        onDone: () {
          _isConnecting = false;
          _scheduleReconnect(token);
        },
        onError: (_) {
          _isConnecting = false;
          _scheduleReconnect(token);
        },
        cancelOnError: true,
      );
    } catch (_) {
      _isConnecting = false;
      _scheduleReconnect(token);
    }
  }

  void _scheduleReconnect(String token) {
    if (_isDisposed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      const Duration(seconds: 5),
      () => connect(token),
    );
  }

  void dispose() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _controller.close();
  }
}
