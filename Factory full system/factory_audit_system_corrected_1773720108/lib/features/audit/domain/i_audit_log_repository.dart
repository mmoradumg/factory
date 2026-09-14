import 'audit_log_entry.dart';

abstract interface class IAuditLogRepository {
  Future<List<AuditLogEntry>> fetchAuditLogs();
  Future<void> clearLocalLogs();
}
