import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryDioInterceptor extends Interceptor {
  static const _startTimeKey = 'request_start_time_ms';

  const SentryDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startTimeKey] = DateTime.now().millisecondsSinceEpoch;
    log('[API REQUEST] ${options.method} ${options.uri}', name: 'SentryDioInterceptor');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final requestOptions = response.requestOptions;
    final durationMs = _extractDurationMs(requestOptions);
    final requestHeaders = _sanitizeHeaders(requestOptions.headers);
    final responseHeaders = _sanitizeHeaders(response.headers.map);

    await Sentry.addBreadcrumb(
      Breadcrumb(
        category: 'http',
        type: 'http',
        level: SentryLevel.info,
        message: '${requestOptions.method} ${requestOptions.path}',
        data: {
          'method': requestOptions.method,
          'url': requestOptions.uri.toString(),
          'path': requestOptions.path,
          'status_code': response.statusCode,
          'duration_ms': durationMs,
          'request_headers': requestHeaders,
          'response_headers': responseHeaders,
          'request_body_size': _estimateSize(requestOptions.data),
          'response_body_size': _estimateSize(response.data),
        },
      ),
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final durationMs = _extractDurationMs(requestOptions);
    final requestHeaders = _sanitizeHeaders(requestOptions.headers);
    final responseHeaders = _sanitizeHeaders(err.response?.headers.map ?? {});

    await Sentry.addBreadcrumb(
      Breadcrumb(
        category: 'http.error',
        type: 'http',
        level: SentryLevel.error,
        message: '${requestOptions.method} ${requestOptions.path}',
        data: {
          'method': requestOptions.method,
          'url': requestOptions.uri.toString(),
          'path': requestOptions.path,
          'status_code': err.response?.statusCode,
          'duration_ms': durationMs,
          'dio_type': err.type.name,
          'request_headers': requestHeaders,
          'response_headers': responseHeaders,
          'request_body_size': _estimateSize(requestOptions.data),
          'response_body_size': _estimateSize(err.response?.data),
          'error_message': err.message,
        },
      ),
    );

    handler.next(err);
  }

  int? _extractDurationMs(RequestOptions options) {
    final start = options.extra[_startTimeKey];
    if (start is int) {
      return DateTime.now().millisecondsSinceEpoch - start;
    }
    return null;
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> raw) {
    final sanitized = <String, dynamic>{};
    for (final entry in raw.entries) {
      final key = entry.key.toLowerCase();
      if (key == 'authorization' || key == 'cookie' || key == 'set-cookie' || key == 'x-api-key') {
        sanitized[entry.key] = '***REDACTED***';
      } else {
        sanitized[entry.key] = entry.value;
      }
    }
    return sanitized;
  }

  int _estimateSize(dynamic data) {
    if (data == null) return 0;
    try {
      if (data is String) return utf8.encode(data).length;
      return utf8.encode(jsonEncode(data)).length;
    } catch (_) {
      return data.toString().length;
    }
  }
}
