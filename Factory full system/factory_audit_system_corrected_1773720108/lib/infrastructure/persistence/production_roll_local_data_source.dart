import 'package:hive/hive.dart';
import '../../domain/models/production_roll.dart';
import 'adapters/production_roll_adapter.dart';

final class ProductionRollLocalDataSource {
  static const String _boxName = 'production_rolls_v1';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProductionRollAdapter());
    }
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<ProductionRoll>(_boxName);
    }
  }

  Box<ProductionRoll> get _box => Hive.box<ProductionRoll>(_boxName);

  List<ProductionRoll> getAllPending() =>
      _box.values.where((e) => e.syncStatus == RollSyncStatus.pending).toList();

  Future<void> updateSyncStatus(String serial, RollSyncStatus status) async {
    final current = _box.get(serial);
    if (current == null) return;
    await _box.put(serial, current.copyWith(syncStatus: status));
  }
}
