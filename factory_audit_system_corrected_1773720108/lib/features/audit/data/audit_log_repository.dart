import 'package:dio/dio.dart';
import '../domain/audit_log_entry.dart';
import '../domain/i_audit_log_repository.dart';

final class AuditLogRepository implements IAuditLogRepository {
  final Dio _dio;
  const AuditLogRepository(this._dio);

  @override
  Future<List<AuditLogEntry>> fetchAuditLogs() async => const [];

  @override
  Future<void> clearLocalLogs() async {}
}
