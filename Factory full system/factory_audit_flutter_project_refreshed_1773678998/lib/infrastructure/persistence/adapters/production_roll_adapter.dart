import 'package:hive/hive.dart';
import '../../../domain/models/production_roll.dart';

class ProductionRollAdapter extends TypeAdapter<ProductionRoll> {
  @override
  final int typeId = 1;

  static const int _schemaVersion = 1;

  @override
  ProductionRoll read(BinaryReader reader) {
    final version = reader.readByte();
    if (version != _schemaVersion) {
      throw HiveError('Unsupported ProductionRoll schema version: $version');
    }

    final rollSerial = reader.readString();
    final productionRunId = reader.readInt();
    final rollNo = reader.readInt();
    final rollLengthM = reader.readDouble();
    final rollWeightKg = reader.readDouble();
    final syncStatusRaw = reader.readString();
    final createdAtMillis = reader.readInt();

    return ProductionRoll(
      rollSerial: rollSerial,
      productionRunId: productionRunId,
      rollNo: rollNo,
      rollLengthM: rollLengthM,
      rollWeightKg: rollWeightKg,
      syncStatus: _parseSyncStatus(syncStatusRaw),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
    );
  }

  @override
  void write(BinaryWriter writer, ProductionRoll obj) {
    writer.writeByte(_schemaVersion);
    writer.writeString(obj.rollSerial);
    writer.writeInt(obj.productionRunId);
    writer.writeInt(obj.rollNo);
    writer.writeDouble(obj.rollLengthM);
    writer.writeDouble(obj.rollWeightKg);
    writer.writeString(obj.syncStatus.name.toUpperCase());
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }

  RollSyncStatus _parseSyncStatus(String raw) {
    switch (raw) {
      case 'SYNCED':
        return RollSyncStatus.synced;
      case 'FAILED':
        return RollSyncStatus.failed;
      default:
        return RollSyncStatus.pending;
    }
  }
}
