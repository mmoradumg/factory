import 'package:flutter/material.dart';
import '../../../../core/network/realtime_sync_service.dart';
import '../../domain/audit_log_entry.dart';
import '../../domain/i_audit_log_repository.dart';
import '../widgets/audit_log_widgets.dart';
import 'audit_log_dashboard_screen.dart';

class AuditLogHostScreen extends StatefulWidget {
  final IAuditLogRepository repository;
  final RealtimeSyncService realtimeService;

  const AuditLogHostScreen({
    super.key,
    required this.repository,
    required this.realtimeService,
  });

  @override
  State<AuditLogHostScreen> createState() => _AuditLogHostScreenState();
}

class _AuditLogHostScreenState extends State<AuditLogHostScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<AuditLogEntry> _logs = const [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final logs = await widget.repository.fetchAuditLogs();
      if (!mounted) return;
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  DashboardStats _stats() => DashboardStats(
        totalEvents: _logs.length,
        pendingSync: 0,
        successRate: _logs.isEmpty ? 0 : 1,
      );

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null) return Scaffold(body: AuditErrorState(message: _error!, onRetry: _load));
    return AuditLogDashboardScreen(
      logs: _logs,
      stats: _stats(),
      isConnected: true,
      onRefresh: _load,
      onClear: null,
      liveFeedListKey: _listKey,
    );
  }
}
