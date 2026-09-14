import 'package:hive/hive.dart';

enum SyncQueueStatus {
  pending,
  synced,
  failed,
}

final class SyncQueueRecord {
  final String dedupeKey;
  final String entityType;
  final String entityId;
  final String actionType;
  final String payloadJson;
  final String deviceId;
  final SyncQueueStatus status;
  final int retryCount;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SyncQueueRecord({
    required this.dedupeKey,
    required this.entityType,
    required this.entityId,
    required this.actionType,
    required this.payloadJson,
    required this.deviceId,
    this.status = SyncQueueStatus.pending,
    this.retryCount = 0,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  SyncQueueRecord copyWith({
    String? dedupeKey,
    String? entityType,
    String? entityId,
    String? actionType,
    String? payloadJson,
    String? deviceId,
    SyncQueueStatus? status,
    int? retryCount,
    String? errorMessage,
    bool clearErrorMessage = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SyncQueueRecord(
      dedupeKey: dedupeKey ?? this.dedupeKey,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      actionType: actionType ?? this.actionType,
      payloadJson: payloadJson ?? this.payloadJson,
      deviceId: deviceId ?? this.deviceId,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  void validate() {
    if (dedupeKey.trim().isEmpty) throw ArgumentError('dedupeKey must not be empty');
    if (entityType.trim().isEmpty) throw ArgumentError('entityType must not be empty');
    if (entityId.trim().isEmpty) throw ArgumentError('entityId must not be empty');
    if (actionType.trim().isEmpty) throw ArgumentError('actionType must not be empty');
    if (payloadJson.trim().isEmpty) throw ArgumentError('payloadJson must not be empty');
    if (deviceId.trim().isEmpty) throw ArgumentError('deviceId must not be empty');
    if (retryCount < 0) throw ArgumentError('retryCount must not be negative');
  }
}
