import '../domain/audit_log_entry.dart';
import '../domain/i_audit_log_repository.dart';

final class FakeAuditLogRepository implements IAuditLogRepository {
  const FakeAuditLogRepository();

  @override
  Future<List<AuditLogEntry>> fetchAuditLogs() async {
    final now = DateTime.now();
    return [
      AuditLogEntry(id: 1, entityType: 'PRODUCTION_ROLL', entityId: 'ROLL-1001', actionType: 'CREATE', actorName: 'أحمد مراد', createdAt: now),
      AuditLogEntry(id: 2, entityType: 'LEAVE_REQUEST', entityId: 'LV-001', actionType: 'APPROVE', actorName: 'محمد السيد', createdAt: now.subtract(const Duration(minutes: 5))),
    ];
  }

  @override
  Future<void> clearLocalLogs() async {}
}
