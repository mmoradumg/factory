import 'package:dio/dio.dart';
import '../domain/audit_log_entry.dart';
import 'audit_log_repository.dart';

final class AuditLogRepositoryException implements Exception {
  final String message;
  final int? statusCode;

  const AuditLogRepositoryException(this.message, {this.statusCode});

  @override
  String toString() => 'AuditLogRepositoryException(message: $message, statusCode: $statusCode)';
}

final class DioAuditLogRepository implements AuditLogRepository {
  final Dio _dio;

  const DioAuditLogRepository(this._dio);

  @override
  Future<List<AuditLogEntry>> fetchAuditLogs({
    int page = 1,
    int limit = 50,
    String? entityType,
    String? actionType,
  }) async {
    if (page <= 0) {
      throw const AuditLogRepositoryException('رقم الصفحة يجب أن يكون أكبر من صفر');
    }

    if (limit <= 0 || limit > 200) {
      throw const AuditLogRepositoryException('عدد العناصر يجب أن يكون بين 1 و 200');
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/audit/logs',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (entityType != null && entityType.trim().isNotEmpty)
            'entity_type': entityType.trim(),
          if (actionType != null && actionType.trim().isNotEmpty)
            'action_type': actionType.trim(),
        },
      );

      final data = response.data;
      if (data == null) {
        throw const AuditLogRepositoryException('لم يتم استلام بيانات من السيرفر');
      }

      final List<dynamic> raw = data['data'] ?? data['items'] ?? data['results'] ?? const [];

      return raw.whereType<Map<String, dynamic>>().map(AuditLogEntry.fromJson).toList(growable: false);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on AuditLogRepositoryException {
      rethrow;
    } catch (e) {
      throw AuditLogRepositoryException('حدث خطأ غير متوقع: $e');
    }
  }

  AuditLogRepositoryException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const AuditLogRepositoryException('انتهت مهلة الاتصال بالسيرفر');
      case DioExceptionType.receiveTimeout:
        return const AuditLogRepositoryException('السيرفر يستغرق وقتاً طويلاً للرد');
      case DioExceptionType.badResponse:
        return AuditLogRepositoryException(
          'خطأ من السيرفر: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.sendTimeout:
        return const AuditLogRepositoryException('انتهت مهلة إرسال الطلب');
      default:
        return const AuditLogRepositoryException('تأكد من اتصالك بالإنترنت');
    }
  }
}
