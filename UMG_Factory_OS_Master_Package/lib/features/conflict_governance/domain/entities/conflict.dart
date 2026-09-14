final class Conflict {
  final String id;
  final String entityType;
  final String entityId;
  final Map<String, dynamic> clientData;
  final Map<String, dynamic> serverData;

  const Conflict({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.clientData,
    required this.serverData,
  });
}
