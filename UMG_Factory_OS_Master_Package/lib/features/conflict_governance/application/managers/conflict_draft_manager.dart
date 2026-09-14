import '../../domain/entities/conflict.dart';
import '../../domain/entities/conflict_resolution.dart';
import '../../domain/entities/map_diff.dart';

final class ConflictDraftManager {
  final Conflict conflict;
  final MapDiff diffTree;
  final Map<String, dynamic> _mergedPayload;
  String? _note;

  ConflictDraftManager({required this.conflict, required this.diffTree})
      : _mergedPayload = Map<String, dynamic>.from(conflict.serverData);

  Map<String, dynamic> get mergedPayload => Map.unmodifiable(_mergedPayload);

  void setField(String key, dynamic value) => _mergedPayload[key] = value;
  void setNote(String? value) => _note = value;

  ConflictResolution finalize() {
    return MergeResolution(Map<String, dynamic>.from(_mergedPayload), reason: _note);
  }
}
