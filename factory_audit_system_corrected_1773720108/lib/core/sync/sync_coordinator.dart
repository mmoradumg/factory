import '../device/device_identity_provider.dart';
import '../../domain/mappers/production_roll_sync_mapper.dart';
import '../../infrastructure/persistence/production_roll_local_data_source.dart';
import 'sync_remote_api.dart';

final class SyncCoordinator {
  final ProductionRollLocalDataSource _localDS;
  final SyncRemoteApi _remoteApi;
  final ProductionRollSyncMapper _mapper;
  final DeviceIdentityProvider _deviceIdentityProvider;

  SyncCoordinator({
    required ProductionRollLocalDataSource localDS,
    required SyncRemoteApi remoteApi,
    required ProductionRollSyncMapper mapper,
    required DeviceIdentityProvider deviceIdentityProvider,
  })  : _localDS = localDS,
        _remoteApi = remoteApi,
        _mapper = mapper,
        _deviceIdentityProvider = deviceIdentityProvider;
}
