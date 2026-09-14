enum RollSyncStatus {
  pending,
  synced,
  failed,
}

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

  factory ProductionRoll.fromJson(Map<String, dynamic> json) {
    return ProductionRoll(
      rollSerial: (json['roll_serial'] ?? '').toString(),
      productionRunId: _toInt(json['production_run_id']),
      rollNo: _toInt(json['roll_no']),
      rollLengthM: _toDouble(json['roll_length_m']),
      rollWeightKg: _toDouble(json['roll_weight_kg']),
      syncStatus: _parseSyncStatus(json['sync_status']),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  ProductionRoll copyWith({
    String? rollSerial,
    int? productionRunId,
    int? rollNo,
    double? rollLengthM,
    double? rollWeightKg,
    RollSyncStatus? syncStatus,
    DateTime? createdAt,
  }) {
    return ProductionRoll(
      rollSerial: rollSerial ?? this.rollSerial,
      productionRunId: productionRunId ?? this.productionRunId,
      rollNo: rollNo ?? this.rollNo,
      rollLengthM: rollLengthM ?? this.rollLengthM,
      rollWeightKg: rollWeightKg ?? this.rollWeightKg,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roll_serial': rollSerial,
      'production_run_id': productionRunId,
      'roll_no': rollNo,
      'roll_length_m': rollLengthM,
      'roll_weight_kg': rollWeightKg,
      'sync_status': syncStatus.name.toUpperCase(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  void validate() {
    if (rollSerial.trim().isEmpty) {
      throw ArgumentError('rollSerial must not be empty');
    }
    if (productionRunId <= 0) {
      throw ArgumentError('productionRunId must be a positive integer');
    }
    if (rollNo <= 0) {
      throw ArgumentError('rollNo must be a positive integer');
    }
    if (rollLengthM <= 0) {
      throw ArgumentError('rollLengthM must be greater than zero');
    }
    if (rollWeightKg <= 0) {
      throw ArgumentError('rollWeightKg must be greater than zero');
    }
  }

  bool get isPending => syncStatus == RollSyncStatus.pending;
  bool get isSynced => syncStatus == RollSyncStatus.synced;
  bool get isFailed => syncStatus == RollSyncStatus.failed;

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    final parsed = int.tryParse((value ?? '').toString());
    if (parsed == null) {
      throw ArgumentError('Invalid integer value: $value');
    }
    return parsed;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    final parsed = double.tryParse((value ?? '').toString());
    if (parsed == null) {
      throw ArgumentError('Invalid double value: $value');
    }
    return parsed;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    final parsed = DateTime.tryParse((value ?? '').toString());
    if (parsed != null) return parsed;
    return DateTime.now();
  }

  static RollSyncStatus _parseSyncStatus(dynamic value) {
    switch ((value ?? '').toString().toUpperCase()) {
      case 'SYNCED':
        return RollSyncStatus.synced;
      case 'FAILED':
        return RollSyncStatus.failed;
      case 'PENDING':
      default:
        return RollSyncStatus.pending;
    }
  }
}
