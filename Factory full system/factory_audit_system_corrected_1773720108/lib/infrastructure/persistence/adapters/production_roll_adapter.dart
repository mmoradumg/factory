import 'package:hive/hive.dart';
import '../../../domain/models/production_roll.dart';

class ProductionRollAdapter extends TypeAdapter<ProductionRoll> {
  @override
  final int typeId = 1;

  @override
  ProductionRoll read(BinaryReader reader) {
    return ProductionRoll(
      rollSerial: reader.readString(),
      productionRunId: reader.readInt(),
      rollNo: reader.readInt(),
      rollLengthM: reader.readDouble(),
      rollWeightKg: reader.readDouble(),
      syncStatus: RollSyncStatus.values[reader.readInt()],
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, ProductionRoll obj) {
    writer.writeString(obj.rollSerial);
    writer.writeInt(obj.productionRunId);
    writer.writeInt(obj.rollNo);
    writer.writeDouble(obj.rollLengthM);
    writer.writeDouble(obj.rollWeightKg);
    writer.writeInt(obj.syncStatus.index);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
