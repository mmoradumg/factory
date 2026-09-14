import '../../../../core/auth/admin_role.dart';
import '../../../../core/error/governance_exception.dart';
import '../../domain/entities/conflict.dart';
import '../../domain/entities/conflict_resolution.dart';

final class CommitResolutionUseCase {
  const CommitResolutionUseCase();

  Future<void> call({
    required Conflict conflict,
    required ConflictResolution resolution,
    required String actorName,
    required AdminRole actorRole,
  }) async {
    if (actorName.trim().isEmpty) {
      throw const ValidationException('يجب تحديد المسؤول عن القرار');
    }
    if (actorRole == AdminRole.worker) {
      throw const PermissionDeniedException('هذا الإجراء يتطلب صلاحية أعلى من مستوى العامل');
    }
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }
}
