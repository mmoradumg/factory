final class SyncQueueLocalDataSource {
  const SyncQueueLocalDataSource();
}

enum SyncQueueStatus { pending, synced, failed }

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
}
