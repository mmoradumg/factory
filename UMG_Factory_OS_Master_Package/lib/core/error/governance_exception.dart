sealed class GovernanceException implements Exception {
  final String message;
  const GovernanceException(this.message);
}

final class ValidationException extends GovernanceException {
  const ValidationException(super.message);
}

final class PermissionDeniedException extends GovernanceException {
  const PermissionDeniedException(super.message);
}

final class SyncEngineException extends GovernanceException {
  const SyncEngineException(super.message);
}
