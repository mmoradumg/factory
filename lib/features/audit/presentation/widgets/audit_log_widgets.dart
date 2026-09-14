import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/audit_log_entry.dart';

Color auditActionColor(String action) {
  switch (action.toUpperCase()) {
    case 'CREATE':
      return Colors.green;
    case 'UPDATE':
      return Colors.blue;
    case 'DELETE':
      return Colors.red;
    case 'APPROVE':
      return Colors.teal;
    case 'REJECT':
      return Colors.deepOrange;
    default:
      return Colors.grey;
  }
}

IconData auditActionIcon(String action) {
  switch (action.toUpperCase()) {
    case 'CREATE':
      return Icons.add_circle_outline;
    case 'UPDATE':
      return Icons.edit_outlined;
    case 'DELETE':
      return Icons.delete_outline;
    case 'APPROVE':
      return Icons.check_circle_outline;
    case 'REJECT':
      return Icons.cancel_outlined;
    default:
      return Icons.info_outline;
  }
}

SliverAppBar buildModernAuditAppBar({
  required BuildContext context,
  required String title,
  required bool isConnected,
  Future<void> Function()? onRefresh,
  VoidCallback? onOpenLiveFeed,
  VoidCallback? onClear,
}) {
  return SliverAppBar(
    expandedHeight: 118,
    floating: true,
    pinned: true,
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      background: Container(color: Colors.white),
    ),
    actions: [
      if (onOpenLiveFeed != null)
        IconButton(
          tooltip: 'البث المباشر',
          icon: const Icon(Icons.stream),
          onPressed: onOpenLiveFeed,
        ),
      if (onRefresh != null)
        IconButton(
          tooltip: 'تحديث',
          icon: const Icon(Icons.refresh),
          onPressed: () => onRefresh(),
        ),
      if (onClear != null)
        IconButton(
          tooltip: 'مسح',
          icon: const Icon(Icons.clear_all),
          onPressed: onClear,
        ),
      Padding(
        padding: const EdgeInsetsDirectional.only(end: 12),
        child: _ConnectionBadge(isConnected: isConnected),
      ),
    ],
  );
}

class _ConnectionBadge extends StatelessWidget {
  final bool isConnected;

  const _ConnectionBadge({
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    final color = isConnected ? Colors.green : Colors.red;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 4, backgroundColor: color),
            const SizedBox(width: 6),
            Text(
              isConnected ? 'متصل' : 'منقطع',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuditLogTile extends StatelessWidget {
  final AuditLogEntry entry;

  const AuditLogTile({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final color = auditActionColor(entry.actionType);

    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.10),
          child: Icon(
            auditActionIcon(entry.actionType),
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          '${entry.actorName ?? "مجهول"} قام بـ ${entry.actionType}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الكيان: ${entry.entityType}'),
              Text('رقم السجل: ${entry.entityId}'),
              const SizedBox(height: 4),
              Text(
                DateFormat('yyyy-MM-dd HH:mm:ss').format(entry.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: () => _showDetails(context, entry),
      ),
    );
  }

  void _showDetails(BuildContext context, AuditLogEntry entry) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تفاصيل السجل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 28),
            _DetailRow('المستخدم', entry.actorName ?? 'N/A'),
            _DetailRow('رمز المستخدم', entry.actorUserId ?? 'N/A'),
            _DetailRow('نوع العملية', entry.actionType),
            _DetailRow('نوع الكيان', entry.entityType),
            _DetailRow('رقم السجل', entry.entityId),
            _DetailRow('IP Address', entry.ipAddress ?? 'Unknown'),
            _DetailRow('الجهاز/المتصفح', entry.userAgent ?? 'Unknown'),
            _DetailRow(
              'التوقيت',
              DateFormat('yyyy-MM-dd HH:mm:ss').format(entry.createdAt),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class AuditEmptyState extends StatelessWidget {
  final String message;

  const AuditEmptyState({
    super.key,
    this.message = 'لا توجد سجلات حالياً',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(message),
        ],
      ),
    );
  }
}

class AuditErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AuditErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
