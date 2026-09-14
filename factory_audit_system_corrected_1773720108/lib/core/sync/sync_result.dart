final class SyncResult {
  final int attempted;
  final int synced;
  final int failedTerminal;
  final int skipped;
  final bool stoppedByRetryableFailure;
  final bool isAlreadyRunning;
  final String? lastError;

  const SyncResult({
    required this.attempted,
    required this.synced,
    required this.failedTerminal,
    required this.skipped,
    required this.stoppedByRetryableFailure,
    required this.isAlreadyRunning,
    this.lastError,
  });

  factory SyncResult.empty() => const SyncResult(
        attempted: 0,
        synced: 0,
        failedTerminal: 0,
        skipped: 0,
        stoppedByRetryableFailure: false,
        isAlreadyRunning: false,
      );
}
