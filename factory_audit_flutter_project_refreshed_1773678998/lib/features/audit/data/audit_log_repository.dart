import '../domain/audit_log_entry.dart';

abstract interface class AuditLogRepository {
  Future<List<AuditLogEntry>> fetchAuditLogs({
    int page = 1,
    int limit = 50,
    String? entityType,
    String? actionType,
  });
}
