sealed class ConflictResolution {
  const ConflictResolution();
}

final class MergeResolution extends ConflictResolution {
  final Map<String, dynamic> payload;
  final String? reason;
  const MergeResolution(this.payload, {this.reason});
}

final class UseClientResolution extends ConflictResolution {
  final String? reason;
  const UseClientResolution([this.reason]);
}

final class UseServerResolution extends ConflictResolution {
  final String? reason;
  const UseServerResolution([this.reason]);
}

final class DeferResolution extends ConflictResolution {
  final String reason;
  const DeferResolution(this.reason);
}

final class DismissResolution extends ConflictResolution {
  final String auditNote;
  const DismissResolution(this.auditNote);
}
