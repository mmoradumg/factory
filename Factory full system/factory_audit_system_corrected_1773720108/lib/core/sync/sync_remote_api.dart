import 'package:dio/dio.dart';
import '../../infrastructure/persistence/sync_queue_local_data_source.dart';

abstract interface class SyncRemoteApi {
  Future<void> pushEvent(SyncQueueRecord record);
}

final class DioSyncRemoteApi implements SyncRemoteApi {
  final Dio dio;
  const DioSyncRemoteApi({required this.dio});

  @override
  Future<void> pushEvent(SyncQueueRecord record) async {
    await dio.post('/sync/events', data: {'entity_id': record.entityId});
  }
}
