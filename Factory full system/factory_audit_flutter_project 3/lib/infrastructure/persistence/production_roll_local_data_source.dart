import 'package:hive/hive.dart';

import '../../domain/models/production_roll.dart';
import 'adapters/production_roll_adapter.dart';

final class ProductionRollLocalDataSource {
  static const String _boxName = 'production_rolls_v1';
  static const int _productionRollTypeId = 1;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(_productionRollTypeId)) {
      Hive.registerAdapter(ProductionRollAdapter());
    }

    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<ProductionRoll>(_boxName);
    }
  }

  Box<ProductionRoll> get _box => Hive.box<ProductionRoll>(_boxName);

  Future<void> persist(ProductionRoll roll) async {
    roll.validate();
    await _box.put(roll.rollSerial, roll);
  }

  Future<ProductionRoll?> getBySerial(String serial) async {
    if (serial.trim().isEmpty) return null;
    return _box.get(serial);
  }

  List<ProductionRoll> getAllPending() {
    final pending = _box.values
        .where((roll) => roll.syncStatus == RollSyncStatus.pending)
        .toList();

    pending.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return pending;
  }

  Future<void> updateSyncStatus(String serial, RollSyncStatus newStatus) async {
    if (serial.trim().isEmpty) {
      throw ArgumentError('serial must not be empty');
    }

    final roll = _box.get(serial);
    if (roll == null) return;

    final updatedRoll = roll.copyWith(syncStatus: newStatus);
    await _box.put(serial, updatedRoll);
  }

  Future<void> deleteBySerial(String serial) async {
    if (serial.trim().isEmpty) return;
    await _box.delete(serial);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
