import '../../domain/entities/conflict.dart';
import '../../domain/services/recursive_deep_diff.dart';
import '../managers/conflict_draft_manager.dart';

final class PrepareConflictSessionUseCase {
  final RecursiveDeepDiff _diff;

  const PrepareConflictSessionUseCase(this._diff);

  Future<ConflictDraftManager> call(Conflict conflict) async {
    final diffTree = _diff.compare(
      oldValue: conflict.serverData,
      newValue: conflict.clientData,
    );
    return ConflictDraftManager(conflict: conflict, diffTree: diffTree);
  }
}
