import 'package:flutter/material.dart';
import '../../domain/audit_log_entry.dart';

class AuditLogTile extends StatelessWidget {
  final AuditLogEntry entry;
  const AuditLogTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.blue.withOpacity(0.1)),
        title: Text('${entry.actorName ?? 'مجهول'} قام بـ ${entry.actionType}'),
        subtitle: Text(entry.entityType),
      ),
    );
  }
}

class AuditEmptyState extends StatelessWidget {
  final String message;
  const AuditEmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Center(child: Text(message));
}

class AuditErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const AuditErrorState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(child: TextButton(onPressed: onRetry, child: Text(message)));
}
