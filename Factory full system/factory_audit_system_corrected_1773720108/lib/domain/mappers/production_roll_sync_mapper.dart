import 'dart:convert';
import '../models/production_roll.dart';
import '../../infrastructure/persistence/sync_queue_local_data_source.dart';

final class ProductionRollSyncMapper {
  const ProductionRollSyncMapper();

  SyncQueueRecord buildCreateRecord({
    required ProductionRoll roll,
    required String deviceId,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();
    return SyncQueueRecord(
      dedupeKey: 'production_roll|${roll.rollSerial}|CREATE',
      entityType: 'PRODUCTION_ROLL',
      entityId: roll.rollSerial,
      actionType: 'CREATE',
      payloadJson: jsonEncode(roll.toJson()),
      deviceId: deviceId,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }
}
