// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example_project/core/network/realtime_sync_service.dart';
import 'package:example_project/features/audit/data/audit_log_repository.dart';
import 'package:example_project/features/audit/domain/audit_log_entry.dart';
import 'package:example_project/features/audit/presentation/pages/audit_log_host_screen.dart';

final class _EmptyAuditLogRepository implements AuditLogRepository {
  @override
  Future<List<AuditLogEntry>> fetchAuditLogs({
    int page = 1,
    int limit = 50,
    String? entityType,
    String? actionType,
  }) async => const [];
}

void main() {
  testWidgets('shows the audit empty state after loading', (
    WidgetTester tester,
  ) async {
    final realtimeService = RealtimeSyncService(
      Uri.parse('wss://example.test/audit'),
    );
    addTearDown(realtimeService.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: AuditLogHostScreen(
          repository: _EmptyAuditLogRepository(),
          realtimeService: realtimeService,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('رقابة الإنتاج'), findsOneWidget);
    expect(find.text('لا توجد نشاطات حديثة'), findsOneWidget);
  });
}
