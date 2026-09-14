import 'package:dio/dio.dart';

import '../../infrastructure/persistence/sync_queue_local_data_source.dart';

class SyncRemoteException implements Exception {
  final String message;
  final int? statusCode;
  final bool isRetryable;

  const SyncRemoteException(
    this.message, {
    this.statusCode,
    this.isRetryable = false,
  });

  @override
  String toString() {
    return 'SyncRemoteException(message: $message, statusCode: $statusCode, isRetryable: $isRetryable)';
  }
}

abstract interface class SyncRemoteApi {
  Future<void> pushEvent(SyncQueueRecord record);
  Future<void> pushBatch(List<SyncQueueRecord> records);
}

final class DioSyncRemoteApi implements SyncRemoteApi {
  final Dio dio;
  final String syncEndpoint;

  const DioSyncRemoteApi({
    required this.dio,
    this.syncEndpoint = '/sync/events',
  });

  @override
  Future<void> pushEvent(SyncQueueRecord record) async {
    record.validate();

    try {
      final response = await dio.post(
        syncEndpoint,
        data: {
          'device_id': record.deviceId,
          'entity_type': record.entityType,
          'entity_id': record.entityId,
          'action_type': record.actionType,
          'payload_json': record.payloadJson,
          'client_created_at': record.createdAt.toIso8601String(),
          'dedupe_key': record.dedupeKey,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Dedupe-Key': record.dedupeKey,
          },
        ),
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        throw SyncRemoteException(
          'Unexpected HTTP status أثناء المزامنة',
          statusCode: statusCode,
          isRetryable: _isRetryableStatus(statusCode),
        );
      }
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      if (e is SyncRemoteException) rethrow;
      throw SyncRemoteException(
        'Unexpected sync failure: $e',
        isRetryable: false,
      );
    }
  }

  @override
  Future<void> pushBatch(List<SyncQueueRecord> records) async {
    if (records.isEmpty) return;
    for (final record in records) {
      await pushEvent(record);
    }
  }

  SyncRemoteException _mapDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = _extractMessage(e);

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return SyncRemoteException(message, statusCode: statusCode, isRetryable: true);
      case DioExceptionType.badResponse:
        return SyncRemoteException(
          message,
          statusCode: statusCode,
          isRetryable: _isRetryableStatus(statusCode),
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return SyncRemoteException(message, statusCode: statusCode, isRetryable: false);
    }
  }

  bool _isRetryableStatus(int? statusCode) {
    if (statusCode == null) return true;
    return statusCode == 408 ||
        statusCode == 429 ||
        statusCode == 500 ||
        statusCode == 502 ||
        statusCode == 503 ||
        statusCode == 504;
  }

  String _extractMessage(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final serverMessage = data['message'] ?? data['error'] ?? data['detail'];
      if (serverMessage != null) {
        return 'Sync request failed: $serverMessage';
      }
    }

    if (statusCode != null) {
      return 'Sync request failed with status $statusCode';
    }

    return e.message ?? 'Sync request failed';
  }
}
