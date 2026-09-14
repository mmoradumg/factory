import 'dart:developer';

import '../device/device_identity_provider.dart';
import '../../domain/mappers/production_roll_sync_mapper.dart';
import '../../domain/models/production_roll.dart';
import '../../infrastructure/persistence/production_roll_local_data_source.dart';
import 'sync_remote_api.dart';
import 'sync_result.dart';

final class SyncCoordinator {
  final ProductionRollLocalDataSource _localDS;
  final SyncRemoteApi _remoteApi;
  final ProductionRollSyncMapper _mapper;
  final DeviceIdentityProvider _deviceIdentityProvider;

  bool _isProcessing = false;

  SyncCoordinator({
    required ProductionRollLocalDataSource localDS,
    required SyncRemoteApi remoteApi,
    required ProductionRollSyncMapper mapper,
    required DeviceIdentityProvider deviceIdentityProvider,
  }) : _localDS = localDS,
       _remoteApi = remoteApi,
       _mapper = mapper,
       _deviceIdentityProvider = deviceIdentityProvider;

  Future<SyncResult> syncProductionRolls() async {
    if (_isProcessing) {
      return SyncResult.empty().copyWith(skipped: 1, isAlreadyRunning: true);
    }

    _isProcessing = true;
    var result = SyncResult.empty();

    try {
      final pendingRolls = _localDS.getAllPending();

      if (pendingRolls.isEmpty) {
        log('SyncCoordinator: no pending rolls.');
        return result;
      }

      final deviceId = await _deviceIdentityProvider.getDeviceId();

      for (final roll in pendingRolls) {
        result = result.copyWith(attempted: result.attempted + 1);

        try {
          final record = _mapper.buildCreateRecord(roll: roll, deviceId: deviceId);
          await _remoteApi.pushEvent(record);

          await _localDS.updateSyncStatus(roll.rollSerial, RollSyncStatus.synced);

          result = result.copyWith(
            synced: result.synced + 1,
            clearLastError: true,
          );
        } on SyncRemoteException catch (e) {
          if (e.isRetryable) {
            return result.copyWith(
              stoppedByRetryableFailure: true,
              lastError: e.toString(),
            );
          }

          await _localDS.updateSyncStatus(
            roll.rollSerial,
            RollSyncStatus.failed,
          );

          result = result.copyWith(
            failedTerminal: result.failedTerminal + 1,
            lastError: e.toString(),
          );
        } catch (e) {
          return result.copyWith(lastError: e.toString());
        }
      }

      return result;
    } finally {
      _isProcessing = false;
    }
  }
}
