import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/auth_interceptor.dart';
import '../network/dio_factory.dart';
import '../network/realtime_sync_service.dart';
import '../../features/audit/data/audit_log_repository.dart';
import '../../features/audit/data/dio_audit_log_repository.dart';
import '../../features/audit/presentation/pages/audit_log_host_screen.dart';
import '../auth/auth_local_repository.dart';

final sl = GetIt.instance;

final class AppAuthSessionHandler implements AuthSessionHandler {
  @override
  Future<void> onUnauthorized() async {
    // TODO: route to login or notify app shell
  }
}

Future<void> setupLocator() async {
  sl.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepository(),
  );

  sl.registerLazySingleton<AuthSessionHandler>(
    () => AppAuthSessionHandler(),
  );

  sl.registerLazySingleton<Dio>(
    () => buildDio(
      authRepo: sl<AuthLocalRepository>(),
      sessionHandler: sl<AuthSessionHandler>(),
    ),
  );

  sl.registerLazySingleton<RealtimeSyncService>(
    () => RealtimeSyncService(
      Uri.parse('wss://api.factory-system.com/realtime/audit'),
    ),
  );

  sl.registerLazySingleton<AuditLogRepository>(
    () => DioAuditLogRepository(sl<Dio>()),
  );

  sl.registerFactory<AuditLogHostScreen>(
    () => AuditLogHostScreen(
      repository: sl<AuditLogRepository>(),
      realtimeService: sl<RealtimeSyncService>(),
    ),
  );
}
