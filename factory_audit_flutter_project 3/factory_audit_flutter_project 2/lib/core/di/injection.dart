import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../auth/auth_local_repository.dart';
import '../device/device_identity_provider.dart';
import '../network/auth_interceptor.dart';
import '../network/dio_factory.dart';
import '../network/realtime_sync_service.dart';
import '../sync/sync_coordinator.dart';
import '../sync/sync_remote_api.dart';
import '../../domain/mappers/production_roll_sync_mapper.dart';
import '../../features/audit/data/audit_log_repository.dart';
import '../../features/audit/data/dio_audit_log_repository.dart';
import '../../features/audit/presentation/pages/audit_log_host_screen.dart';
import '../../infrastructure/persistence/production_roll_local_data_source.dart';
import '../../infrastructure/persistence/sync_queue_local_data_source.dart';

final sl = GetIt.instance;

final class AppAuthSessionHandler implements AuthSessionHandler {
  @override
  Future<void> onUnauthorized() async {
    // TODO: route to login or notify app shell
  }
}

Future<void> setupLocator() async {
  sl.registerLazySingleton<AuthLocalRepository>(() => AuthLocalRepository());
  sl.registerLazySingleton<AuthSessionHandler>(() => AppAuthSessionHandler());
  sl.registerLazySingleton<DeviceIdentityProvider>(
    () => const StaticDeviceIdentityProvider(deviceId: 'device-001'),
  );

  sl.registerLazySingleton<Dio>(
    () => buildDio(
      authRepo: sl<AuthLocalRepository>(),
      sessionHandler: sl<AuthSessionHandler>(),
    ),
  );

  sl.registerLazySingleton<RealtimeSyncService>(
    () => RealtimeSyncService(Uri.parse('wss://api.factory-system.com/realtime/audit')),
  );

  sl.registerLazySingleton<ProductionRollLocalDataSource>(() => ProductionRollLocalDataSource());
  sl.registerLazySingleton<SyncQueueLocalDataSource>(() => SyncQueueLocalDataSource());
  sl.registerLazySingleton<ProductionRollSyncMapper>(() => const ProductionRollSyncMapper());

  sl.registerLazySingleton<SyncRemoteApi>(() => DioSyncRemoteApi(dio: sl<Dio>()));

  sl.registerLazySingleton<SyncCoordinator>(
    () => SyncCoordinator(
      localDS: sl<ProductionRollLocalDataSource>(),
      remoteApi: sl<SyncRemoteApi>(),
      mapper: sl<ProductionRollSyncMapper>(),
      deviceIdentityProvider: sl<DeviceIdentityProvider>(),
    ),
  );

  sl.registerLazySingleton<AuditLogRepository>(() => DioAuditLogRepository(sl<Dio>()));

  sl.registerFactory<AuditLogHostScreen>(
    () => AuditLogHostScreen(
      repository: sl<AuditLogRepository>(),
      realtimeService: sl<RealtimeSyncService>(),
    ),
  );
}
