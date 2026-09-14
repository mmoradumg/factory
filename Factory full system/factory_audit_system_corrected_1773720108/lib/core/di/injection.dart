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
import '../../features/audit/data/fake_audit_log_repository.dart';
import '../../features/audit/domain/i_audit_log_repository.dart';
import '../../features/audit/presentation/pages/audit_log_host_screen.dart';
import '../../features/hr/data/fake_hr_repository.dart';
import '../../features/hr/data/hr_repository.dart';
import '../../features/hr/domain/i_hr_repository.dart';
import '../../features/hr/presentation/pages/hr_host_screen.dart';
import '../../features/inventory/data/fake_inventory_repository.dart';
import '../../features/inventory/data/inventory_repository.dart';
import '../../features/inventory/domain/i_inventory_repository.dart';
import '../../features/inventory/presentation/pages/inventory_host_screen.dart';
import '../../infrastructure/persistence/production_roll_local_data_source.dart';
import '../../infrastructure/persistence/sync_queue_local_data_source.dart';

final sl = GetIt.instance;
const bool useFakeModules = true;

final class AppAuthSessionHandler implements AuthSessionHandler {
  @override
  Future<void> onUnauthorized() async {}
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
  sl.registerLazySingleton<SyncQueueLocalDataSource>(() => const SyncQueueLocalDataSource());
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

  if (useFakeModules) {
    sl.registerLazySingleton<IAuditLogRepository>(() => const FakeAuditLogRepository());
    sl.registerLazySingleton<IHrRepository>(() => const FakeHrRepository());
    sl.registerLazySingleton<IInventoryRepository>(() => const FakeInventoryRepository());
  } else {
    sl.registerLazySingleton<IAuditLogRepository>(() => AuditLogRepository(sl<Dio>()));
    sl.registerLazySingleton<IHrRepository>(() => HrRepository(sl<Dio>()));
    sl.registerLazySingleton<IInventoryRepository>(() => InventoryRepository(sl<Dio>()));
  }

  sl.registerFactory<AuditLogHostScreen>(
    () => AuditLogHostScreen(
      repository: sl<IAuditLogRepository>(),
      realtimeService: sl<RealtimeSyncService>(),
    ),
  );
  sl.registerFactory<HrHostScreen>(() => HrHostScreen(repository: sl<IHrRepository>()));
  sl.registerFactory<InventoryHostScreen>(() => InventoryHostScreen(repository: sl<IInventoryRepository>()));
}
