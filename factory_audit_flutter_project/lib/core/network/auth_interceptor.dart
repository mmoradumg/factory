import 'package:dio/dio.dart';
import '../auth/auth_local_repository.dart';

abstract interface class AuthSessionHandler {
  Future<void> onUnauthorized();
}

final class AuthInterceptor extends Interceptor {
  final AuthLocalRepository _authRepo;
  final AuthSessionHandler _sessionHandler;

  bool _isHandlingUnauthorized = false;

  AuthInterceptor(this._authRepo, this._sessionHandler);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authRepo.getAccessToken();
    if (token != null && token.trim().isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isHandlingUnauthorized) {
      _isHandlingUnauthorized = true;
      try {
        await _authRepo.clearAll();
        await _sessionHandler.onUnauthorized();
      } finally {
        _isHandlingUnauthorized = false;
      }
    }
    handler.next(err);
  }
}
