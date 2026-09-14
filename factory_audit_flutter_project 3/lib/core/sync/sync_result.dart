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

  factory SyncResult.empty() {
    return const SyncResult(
      attempted: 0,
      synced: 0,
      failedTerminal: 0,
      skipped: 0,
      stoppedByRetryableFailure: false,
      isAlreadyRunning: false,
      lastError: null,
    );
  }

  bool get hasFailures => failedTerminal > 0;
  bool get isFullSuccess => attempted > 0 && synced == attempted;
  bool get isPartialSuccess => synced > 0 && failedTerminal > 0;
  bool get wasSkipped => skipped > 0;
  bool get hasAnyWork => attempted > 0 || synced > 0 || failedTerminal > 0 || skipped > 0;

  SyncResult copyWith({
    int? attempted,
    int? synced,
    int? failedTerminal,
    int? skipped,
    bool? stoppedByRetryableFailure,
    bool? isAlreadyRunning,
    String? lastError,
    bool clearLastError = false,
  }) {
    return SyncResult(
      attempted: attempted ?? this.attempted,
      synced: synced ?? this.synced,
      failedTerminal: failedTerminal ?? this.failedTerminal,
      skipped: skipped ?? this.skipped,
      stoppedByRetryableFailure: stoppedByRetryableFailure ?? this.stoppedByRetryableFailure,
      isAlreadyRunning: isAlreadyRunning ?? this.isAlreadyRunning,
      lastError: clearLastError ? null : (lastError ?? this.lastError),
    );
  }
}
