import '../entities/map_diff.dart';

final class RecursiveDeepDiff {
  const RecursiveDeepDiff();

  MapDiff compare({
    required dynamic oldValue,
    required dynamic newValue,
    String path = r'$',
    String key = r'$',
  }) {
    if (oldValue == null && newValue == null) {
      return MapDiff(path: path, key: key, status: MapDiffStatus.equal, nodeType: MapDiffNodeType.value);
    }
    if (oldValue == null) {
      return MapDiff(path: path, key: key, status: MapDiffStatus.added, nodeType: _typeOf(newValue), newValue: newValue);
    }
    if (newValue == null) {
      return MapDiff(path: path, key: key, status: MapDiffStatus.removed, nodeType: _typeOf(oldValue), oldValue: oldValue);
    }
    final oldIsMap = oldValue is Map;
    final newIsMap = newValue is Map;
    final oldIsList = oldValue is List;
    final newIsList = newValue is List;
    if ((oldIsMap != newIsMap) || (oldIsList != newIsList)) {
      return MapDiff(path: path, key: key, status: MapDiffStatus.typeMismatch, nodeType: _typeOf(newValue), oldValue: oldValue, newValue: newValue);
    }
    if (oldIsMap && newIsMap) {
      final oldMap = Map<String, dynamic>.from(oldValue as Map);
      final newMap = Map<String, dynamic>.from(newValue as Map);
      final keys = <String>{...oldMap.keys, ...newMap.keys}.toList()..sort();
      final children = <String, MapDiff>{};
      for (final k in keys) {
        children[k] = compare(oldValue: oldMap[k], newValue: newMap[k], path: '$path.$k', key: k);
      }
      final changed = children.values.any((e) => e.status != MapDiffStatus.equal);
      return MapDiff(path: path, key: key, status: changed ? MapDiffStatus.changed : MapDiffStatus.equal, nodeType: MapDiffNodeType.object, childDiffs: children);
    }
    if (oldIsList && newIsList) {
      final oldList = oldValue as List;
      final newList = newValue as List;
      final max = oldList.length > newList.length ? oldList.length : newList.length;
      final items = <MapDiff>[];
      for (var i = 0; i < max; i++) {
        items.add(compare(oldValue: i < oldList.length ? oldList[i] : null, newValue: i < newList.length ? newList[i] : null, path: '$path[$i]', key: '[$i]'));
      }
      final changed = items.any((e) => e.status != MapDiffStatus.equal);
      return MapDiff(path: path, key: key, status: changed ? MapDiffStatus.changed : MapDiffStatus.equal, nodeType: MapDiffNodeType.array, itemDiffs: items);
    }
    return MapDiff(path: path, key: key, status: oldValue == newValue ? MapDiffStatus.equal : MapDiffStatus.changed, nodeType: MapDiffNodeType.value, oldValue: oldValue, newValue: newValue);
  }

  MapDiffNodeType _typeOf(dynamic value) {
    if (value is Map) return MapDiffNodeType.object;
    if (value is List) return MapDiffNodeType.array;
    return MapDiffNodeType.value;
  }
}
