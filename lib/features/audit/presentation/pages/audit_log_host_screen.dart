import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/network/realtime_sync_service.dart';
import '../../data/audit_log_repository.dart';
import '../../domain/audit_log_entry.dart';
import '../../domain/operations_alert.dart';
import '../widgets/audit_log_widgets.dart';
import 'audit_log_dashboard_screen.dart';

class AuditLogHostScreen extends StatefulWidget {
  final AuditLogRepository repository;
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
  final List<AuditLogEntry> _currentLogs = [];
  final List<OperationsAlert> _alerts = [];

  StreamSubscription<Map<String, dynamic>>? _auditSub;
  DateTime? _lastHapticAt;

  bool _isLoading = true;
  bool _isConnected = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initialLoad();
    _setupRealtimeListener();
  }

  Future<void> _initialLoad() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final logs = await widget.repository.fetchAuditLogs();

      if (!mounted) return;
      setState(() {
        _currentLogs
          ..clear()
          ..addAll(logs);
        _alerts
          ..clear()
          ..addAll(_buildAlerts(logs));
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _setupRealtimeListener() {
    _auditSub = widget.realtimeService.syncStream.listen(
      (data) {
        try {
          final entry = AuditLogEntry.fromJson(data);
          if (!mounted) return;

          setState(() => _isConnected = true);
          _insertRealtimeEntry(entry);
        } catch (e) {
          log('Failed to parse realtime entry: $e');
        }
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _isConnected = false);
      },
      onDone: () {
        if (!mounted) return;
        setState(() => _isConnected = false);
      },
      cancelOnError: false,
    );
  }

  void _insertRealtimeEntry(AuditLogEntry entry) {
    final wasEmpty = _currentLogs.isEmpty;

    _triggerSensoryFeedback(entry.actionType);
    _currentLogs.insert(0, entry);

    if (wasEmpty) {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listKey.currentState?.insertItem(
          0,
          duration: const Duration(milliseconds: 600),
        );
      });
      return;
    }

    _listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 600),
    );
  }

  void _triggerSensoryFeedback(String action) {
    final now = DateTime.now();

    if (_lastHapticAt != null &&
        now.difference(_lastHapticAt!) < const Duration(milliseconds: 400)) {
      return;
    }

    _lastHapticAt = now;

    switch (action.toUpperCase()) {
      case 'DELETE':
      case 'REJECT':
        HapticFeedback.heavyImpact();
        break;
      case 'APPROVE':
        HapticFeedback.mediumImpact();
        break;
      case 'CREATE':
        HapticFeedback.lightImpact();
        break;
      case 'UPDATE':
        HapticFeedback.selectionClick();
        break;
      default:
        HapticFeedback.selectionClick();
    }
  }

  void _clearLogs() {
    _currentLogs.clear();
    _alerts.clear();
    setState(() {});
  }

  List<OperationsAlert> _buildAlerts(List<AuditLogEntry> logs) {
    final alerts = <OperationsAlert>[];
    final rejected = logs.where(
      (entry) => entry.actionType.toUpperCase() == 'REJECT',
    );
    final pending = logs.where(
      (entry) => entry.actionType.toUpperCase() == 'PENDING',
    );

    if (rejected.isNotEmpty) {
      alerts.add(
        OperationsAlert(
          id: 'rejected-${rejected.first.id}',
          title: 'عمليات مرفوضة تحتاج مراجعة',
          description:
              'تم رصد ${rejected.length} عملية مرفوضة في السجل الحالي.',
          severity: AlertSeverity.critical,
          source: 'Audit Log',
          createdAt: rejected.first.createdAt,
        ),
      );
    }

    if (pending.isNotEmpty) {
      alerts.add(
        OperationsAlert(
          id: 'pending-${pending.first.id}',
          title: 'عمليات قيد المزامنة',
          description: '${pending.length} عملية لم تكتمل مزامنتها بعد.',
          severity: AlertSeverity.warning,
          source: 'Synchronization',
          createdAt: pending.first.createdAt,
        ),
      );
    }

    return alerts;
  }

  void _updateAlert(String alertId, {String? assignee, AlertStatus? status}) {
    final index = _alerts.indexWhere((alert) => alert.id == alertId);
    if (index == -1) return;

    setState(() {
      _alerts[index] = _alerts[index].copyWith(
        assignee: assignee,
        status: status,
      );
    });
  }

  DashboardStats _buildStats() {
    final totalEvents = _currentLogs.length;

    final pendingSync = _currentLogs
        .where((e) => e.actionType.toUpperCase() == 'PENDING')
        .length;

    final successCount = _currentLogs
        .where((e) => e.actionType.toUpperCase() != 'REJECT')
        .length;

    final successRate = totalEvents == 0 ? 0.0 : successCount / totalEvents;

    return DashboardStats(
      totalEvents: totalEvents,
      pendingSync: pendingSync,
      successRate: successRate,
    );
  }

  @override
  void dispose() {
    _auditSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: AuditErrorState(message: _errorMessage!, onRetry: _initialLoad),
      );
    }

    return AuditLogDashboardScreen(
      logs: _currentLogs,
      stats: _buildStats(),
      alerts: _alerts,
      isConnected: _isConnected,
      onRefresh: _initialLoad,
      onClear: _currentLogs.isEmpty ? null : _clearLogs,
      onAssignAlert: (alert) => _updateAlert(
        alert.id,
        assignee: 'الإدارة',
        status: AlertStatus.assigned,
      ),
      onResolveAlert: (alert) =>
          _updateAlert(alert.id, status: AlertStatus.resolved),
      liveFeedListKey: _listKey,
    );
  }
}
