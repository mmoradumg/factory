enum AlertSeverity { critical, warning, info }

enum AlertStatus { open, assigned, resolved }

final class OperationsAlert {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final String source;
  final DateTime createdAt;
  final String? assignee;
  final AlertStatus status;

  const OperationsAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.source,
    required this.createdAt,
    this.assignee,
    this.status = AlertStatus.open,
  });

  OperationsAlert copyWith({String? assignee, AlertStatus? status}) {
    return OperationsAlert(
      id: id,
      title: title,
      description: description,
      severity: severity,
      source: source,
      createdAt: createdAt,
      assignee: assignee ?? this.assignee,
      status: status ?? this.status,
    );
  }
}
