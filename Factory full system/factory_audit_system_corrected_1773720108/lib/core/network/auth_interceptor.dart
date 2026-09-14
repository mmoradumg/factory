import 'package:dio/dio.dart';
import '../auth/auth_local_repository.dart';

abstract interface class AuthSessionHandler {
  Future<void> onUnauthorized();
}

final class AuthInterceptor extends Interceptor {
  final AuthLocalRepository _authRepo;
  final AuthSessionHandler _sessionHandler;

  AuthInterceptor(this._authRepo, this._sessionHandler);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authRepo.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _authRepo.clearAll();
      await _sessionHandler.onUnauthorized();
    }
    handler.next(err);
  }
}
