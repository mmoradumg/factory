final class AuditLogEntry {
  final int id;
  final String entityType;
  final String entityId;
  final String actionType;
  final String? actorName;
  final DateTime createdAt;

  const AuditLogEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.actionType,
    required this.actorName,
    required this.createdAt,
  });
}
