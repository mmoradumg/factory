final class AuditLogEntry {
  final int id;
  final String entityType;
  final String entityId;
  final String actionType;
  final String? actorName;
  final String? actorUserId;
  final String? ipAddress;
  final String? userAgent;
  final DateTime createdAt;

  const AuditLogEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.actionType,
    required this.actorName,
    required this.actorUserId,
    required this.ipAddress,
    required this.userAgent,
    required this.createdAt,
  });

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) {
    return AuditLogEntry(
      id: (json['id'] as num?)?.toInt() ?? 0,
      entityType: (json['entity_type'] ?? '').toString(),
      entityId: (json['entity_id'] ?? '').toString(),
      actionType: (json['action_type'] ?? '').toString(),
      actorName: json['actor_name']?.toString(),
      actorUserId: json['actor_user_id']?.toString(),
      ipAddress: json['ip_address']?.toString(),
      userAgent: json['user_agent']?.toString(),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}
