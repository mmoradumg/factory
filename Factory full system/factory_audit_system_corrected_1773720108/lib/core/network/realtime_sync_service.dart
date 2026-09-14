import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

final class RealtimeSyncService {
  final Uri _url;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  WebSocketChannel? _channel;

  RealtimeSyncService(this._url);

  Stream<Map<String, dynamic>> get syncStream => _controller.stream;

  void connect(String token) {
    _channel = WebSocketChannel.connect(_url.replace(queryParameters: {'token': token}));
  }

  void dispose() {
    _channel?.sink.close();
    _controller.close();
  }
}
