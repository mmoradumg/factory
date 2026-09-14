import 'package:flutter/material.dart';
import '../../domain/audit_log_entry.dart';
import '../widgets/audit_log_widgets.dart';

class AuditLogLiveFeedScreen extends StatelessWidget {
  final List<AuditLogEntry> logs;
  final GlobalKey<AnimatedListState> listKey;
  final bool isConnected;

  const AuditLogLiveFeedScreen({
    super.key,
    required this.logs,
    required this.listKey,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البث المباشر للعمليات')),
      body: logs.isEmpty
          ? const AuditEmptyState(message: 'لا يوجد بث مباشر حالياً')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AuditLogTile(entry: logs[index]),
              ),
            ),
    );
  }
}
