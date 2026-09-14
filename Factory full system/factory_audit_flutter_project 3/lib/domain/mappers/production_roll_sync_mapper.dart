import 'dart:convert';

import '../models/production_roll.dart';
import '../../infrastructure/persistence/sync_queue_local_data_source.dart';

final class ProductionRollSyncMapper {
  const ProductionRollSyncMapper();

  static const String _entityType = 'PRODUCTION_ROLL';
  static const String _createAction = 'CREATE';

  SyncQueueRecord buildCreateRecord({
    required ProductionRoll roll,
    required String deviceId,
    DateTime? now,
  }) {
    roll.validate();

    if (deviceId.trim().isEmpty) {
      throw ArgumentError('deviceId must not be empty');
    }

    final timestamp = now ?? DateTime.now();

    return SyncQueueRecord(
      dedupeKey: _buildDedupeKey(roll.rollSerial, _createAction),
      entityType: _entityType,
      entityId: roll.rollSerial,
      actionType: _createAction,
      payloadJson: jsonEncode(roll.toJson()),
      deviceId: deviceId,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  static String _buildDedupeKey(String serial, String action) {
    return 'production_roll|$serial|$action';
  }
}
