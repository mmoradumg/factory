enum MapDiffStatus { equal, changed, added, removed, typeMismatch, moved }

enum MapDiffNodeType { object, array, value }

final class MapDiff {
  final String path;
  final String key;
  final MapDiffStatus status;
  final MapDiffNodeType nodeType;
  final dynamic oldValue;
  final dynamic newValue;
  final Map<String, MapDiff>? childDiffs;
  final List<MapDiff>? itemDiffs;

  const MapDiff({
    required this.path,
    required this.key,
    required this.status,
    required this.nodeType,
    this.oldValue,
    this.newValue,
    this.childDiffs,
    this.itemDiffs,
  });
}
