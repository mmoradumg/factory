import 'package:dio/dio.dart';
import '../auth/auth_local_repository.dart';
import 'auth_interceptor.dart';

Dio buildDio({
  required AuthLocalRepository authRepo,
  required AuthSessionHandler sessionHandler,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.factory-system.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: const {'Accept': 'application/json', 'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(AuthInterceptor(authRepo, sessionHandler));
  return dio;
}
