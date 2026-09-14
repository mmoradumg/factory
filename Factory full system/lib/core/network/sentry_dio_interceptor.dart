import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class SentryDioInterceptor extends Interceptor {
  static const _startTimeKey = 'request_start_time_ms';

  const SentryDioInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.extra[_startTimeKey] = DateTime.now().millisecondsSinceEpoch;
    log('[API REQUEST] ${options.method} ${options.uri}', name: 'SentryDioInterceptor');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final requestOptions = response.requestOptions;
    final durationMs = _extractDurationMs(requestOptions);
    final requestHeaders = _sanitizeHeaders(requestOptions.headers);
    final responseHeaders = _sanitizeHeaders(response.headers.map);
    final requestBodySize = _estimateSize(requestOptions.data);
    final responseBodySize = _estimateSize(response.data);

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
          'request_body_size': requestBodySize,
          'response_body_size': responseBodySize,
        },
      ),
    );

    final transaction = Sentry.startTransaction(
      'HTTP ${requestOptions.method} ${requestOptions.path}',
      'http.client',
      bindToScope: false,
    );

    transaction.setData('url', requestOptions.uri.toString());
    transaction.setData('status_code', response.statusCode);
    transaction.setData('duration_ms', durationMs);
    transaction.setData('request_headers', requestHeaders);
    transaction.setData('response_headers', responseHeaders);
    transaction.setData('request_body_size', requestBodySize);
    transaction.setData('response_body_size', responseBodySize);

    transaction.finish(status: const SpanStatus.ok());

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final durationMs = _extractDurationMs(requestOptions);
    final requestHeaders = _sanitizeHeaders(requestOptions.headers);
    final responseHeaders = _sanitizeHeaders(err.response?.headers.map ?? {});
    final requestBodySize = _estimateSize(requestOptions.data);
    final responseBodySize = _estimateSize(err.response?.data);

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
          'request_body_size': requestBodySize,
          'response_body_size': responseBodySize,
          'error_message': err.message,
        },
      ),
    );

    await Sentry.captureException(
      err,
      stackTrace: err.stackTrace,
      withScope: (scope) {
        scope.setTag('http.method', requestOptions.method);
        scope.setTag('http.path', requestOptions.path);
        scope.setTag('http.url', requestOptions.uri.toString());
        scope.setTag('dio.error_type', err.type.name);

        if (err.response?.statusCode != null) {
          scope.setTag('http.status_code', '${err.response!.statusCode}');
        }

        scope.setContexts('http_request', {
          'method': requestOptions.method,
          'url': requestOptions.uri.toString(),
          'headers': requestHeaders,
          'body_size': requestBodySize,
        });

        scope.setContexts('http_response', {
          'status_code': err.response?.statusCode,
          'headers': responseHeaders,
          'body_size': responseBodySize,
          'duration_ms': durationMs,
        });
      },
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

      if (key == 'authorization' ||
          key == 'cookie' ||
          key == 'set-cookie' ||
          key == 'x-api-key') {
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
