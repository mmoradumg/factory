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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('البث المباشر للعمليات'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: isConnected ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isConnected ? 'متصل' : 'منقطع',
                    style: TextStyle(
                      color: isConnected ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: logs.isEmpty
          ? const AuditEmptyState(message: 'لا يوجد بث مباشر حالياً')
          : AnimatedList(
              key: listKey,
              initialItemCount: logs.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).chain(
                        CurveTween(curve: Curves.easeOut),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AuditLogTile(entry: logs[index]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
