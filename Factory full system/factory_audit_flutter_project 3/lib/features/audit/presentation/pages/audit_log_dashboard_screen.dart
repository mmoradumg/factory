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
    final visibleLogs = logs.length > 15 ? logs.take(15).toList() : logs;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            buildModernAuditAppBar(
              context: context,
              title: 'رقابة الإنتاج',
              isConnected: isConnected,
              onRefresh: onRefresh,
              onClear: onClear,
              onOpenLiveFeed: () {
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 520;

                    if (isCompact) {
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildStatItem(constraints.maxWidth, 'إجمالي الأحداث', '${stats.totalEvents}', Colors.blue, Icons.analytics_outlined, isHalf: true),
                          _buildStatItem(constraints.maxWidth, 'قيد المزامنة', '${stats.pendingSync}', Colors.orange, Icons.sync_problem, isHalf: true),
                          _buildStatItem(constraints.maxWidth, 'دقة الرفع', '${(stats.successRate * 100).toInt()}%', Colors.teal, Icons.check_circle_outline, isHalf: false),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: _StatCard(label: 'إجمالي الأحداث', value: '${stats.totalEvents}', color: Colors.blue, icon: Icons.analytics_outlined)),
                        const SizedBox(width: 12),
                        Expanded(child: _StatCard(label: 'قيد المزامنة', value: '${stats.pendingSync}', color: Colors.orange, icon: Icons.sync_problem)),
                        const SizedBox(width: 12),
                        Expanded(child: _StatCard(label: 'دقة الرفع', value: '${(stats.successRate * 100).toInt()}%', color: Colors.teal, icon: Icons.check_circle_outline)),
                      ],
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    const Text('أحدث النشاطات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    if (isConnected) const _LiveTag() else const _OfflineTag(),
                    const Spacer(),
                    TextButton.icon(
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
                      label: const Text('البث المباشر'),
                    ),
                  ],
                ),
              ),
            ),
            visibleLogs.isEmpty
                ? const SliverFillRemaining(child: AuditEmptyState(message: 'لا توجد نشاطات حديثة'))
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AuditLogTile(entry: visibleLogs[index]),
                        ),
                        childCount: visibleLogs.length,
                      ),
                    ),
                  ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(double maxWidth, String label, String value, Color color, IconData icon, {required bool isHalf}) {
    return SizedBox(
      width: isHalf ? (maxWidth - 12) / 2 : maxWidth,
      child: _StatCard(label: label, value: value, color: color, icon: icon),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color.withValues(alpha: 0.8)),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _LiveTag extends StatelessWidget {
  const _LiveTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'LIVE',
        style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.black),
      ),
    );
  }
}

class _OfflineTag extends StatelessWidget {
  const _OfflineTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'OFFLINE',
        style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.black),
      ),
    );
  }
}
