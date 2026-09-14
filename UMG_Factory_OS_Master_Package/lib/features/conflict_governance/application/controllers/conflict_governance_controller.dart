import '../../../../core/auth/admin_role.dart';
import '../../domain/entities/conflict.dart';
import '../managers/conflict_draft_manager.dart';
import '../usecases/commit_resolution_use_case.dart';
import '../usecases/prepare_conflict_session_use_case.dart';

final class ConflictGovernanceController {
  final PrepareConflictSessionUseCase _prepareSession;
  final CommitResolutionUseCase _commitResolution;

  const ConflictGovernanceController({
    required PrepareConflictSessionUseCase prepareSession,
    required CommitResolutionUseCase commitResolution,
  })  : _prepareSession = prepareSession,
        _commitResolution = commitResolution;

  Future<ConflictDraftManager> start(Conflict conflict) => _prepareSession(conflict);

  Future<void> finish({
    required Conflict conflict,
    required ConflictDraftManager draft,
    required String actorName,
    required AdminRole actorRole,
  }) {
    return _commitResolution(
      conflict: conflict,
      resolution: draft.finalize(),
      actorName: actorName,
      actorRole: actorRole,
    );
  }
}
