enum RollSyncStatus { pending, synced, failed }

final class ProductionRoll {
  final String rollSerial;
  final int productionRunId;
  final int rollNo;
  final double rollLengthM;
  final double rollWeightKg;
  final RollSyncStatus syncStatus;
  final DateTime createdAt;

  const ProductionRoll({
    required this.rollSerial,
    required this.productionRunId,
    required this.rollNo,
    required this.rollLengthM,
    required this.rollWeightKg,
    this.syncStatus = RollSyncStatus.pending,
    required this.createdAt,
  });

  ProductionRoll copyWith({RollSyncStatus? syncStatus}) {
    return ProductionRoll(
      rollSerial: rollSerial,
      productionRunId: productionRunId,
      rollNo: rollNo,
      rollLengthM: rollLengthM,
      rollWeightKg: rollWeightKg,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'roll_serial': rollSerial,
        'production_run_id': productionRunId,
        'roll_no': rollNo,
        'roll_length_m': rollLengthM,
        'roll_weight_kg': rollWeightKg,
        'sync_status': syncStatus.name.toUpperCase(),
        'created_at': createdAt.toIso8601String(),
      };
}
