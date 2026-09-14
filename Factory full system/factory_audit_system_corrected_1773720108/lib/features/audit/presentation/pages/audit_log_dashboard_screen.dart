import 'package:flutter/material.dart';
import '../../domain/audit_log_entry.dart';
import '../widgets/audit_log_widgets.dart';
import 'audit_log_live_feed_screen.dart';

final class DashboardStats {
  final int totalEvents;
  final int pendingSync;
  final double successRate;

  const DashboardStats({
    required this.totalEvents,
    required this.pendingSync,
    required this.successRate,
  });
}

class AuditLogDashboardScreen extends StatelessWidget {
  final List<AuditLogEntry> logs;
  final DashboardStats stats;
  final bool isConnected;
  final Future<void> Function() onRefresh;
  final VoidCallback? onClear;
  final GlobalKey<AnimatedListState> liveFeedListKey;

  const AuditLogDashboardScreen({
    super.key,
    required this.logs,
    required this.stats,
    required this.isConnected,
    required this.onRefresh,
    required this.onClear,
    required this.liveFeedListKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('رقابة الإنتاج')),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(child: _StatCard(label: 'إجمالي الأحداث', value: '${stats.totalEvents}', color: Colors.blue, icon: Icons.analytics_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'قيد المزامنة', value: '${stats.pendingSync}', color: Colors.orange, icon: Icons.sync_problem)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'دقة الرفع', value: '${(stats.successRate * 100).toInt()}%', color: Colors.teal, icon: Icons.check_circle_outline)),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuditLogLiveFeedScreen(
                        logs: logs,
                        listKey: liveFeedListKey,
                        isConnected: isConnected,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.stream, size: 16),
                label: Text(isConnected ? 'LIVE' : 'OFFLINE'),
              ),
            ),
            const SizedBox(height: 8),
            if (logs.isEmpty)
              const SizedBox(height: 300, child: AuditEmptyState(message: 'لا توجد نشاطات حديثة'))
            else
              ...logs.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AuditLogTile(entry: e),
                  )),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color.withOpacity(0.8)),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
