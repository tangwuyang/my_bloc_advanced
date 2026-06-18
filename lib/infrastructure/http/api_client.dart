
import 'package:dio/dio.dart';

import '../../core/logging/app_logger.dart';

/// Metadata describing one entry in the [ApiClient] interceptor chain.
///
/// Used by the system dashboard and other observers that want to render
/// the chain without hard-coding names/descriptions. Order matches the
/// order in which the interceptor was added to Dio.
class InterceptorChainEntry {
  const InterceptorChainEntry({required this.name, required this.detail, this.active = true});

  final String name;
  final String detail;
  final bool active;
}


/// Dio-based HTTP client with interceptor chain.
///
/// Interceptor order (single source of truth — see `_chainEntries` below):
/// 1. [ConnectivityInterceptor] — rejects requests immediately when offline
/// 2. [AuthInterceptor] — injects JWT token
/// 3. [TokenRefreshInterceptor] — handles 401 responses with token refresh
/// 4. [ResilienceInterceptor] — smart retry + circuit breaker
/// 5. [MockInterceptor] — (dev/test only) short-circuits with mock data
/// 6. [CacheInterceptor] — GET response caching with TTL
/// 7. [DevConsoleInterceptor] — records requests in debug console
/// 8. [LoggingInterceptor] — structured request/response logging
///
/// Error mapping happens in the convenience methods ([get], [post], etc.)
/// which catch [DioException] and rethrow as [AppException] types so that
/// repository catch blocks work without Dio coupling.
class ApiClient{
  static final _log = AppLogger.getLogger('ApiClient');

  static const int _timeoutSeconds = 30;

  static Dio? _dio;
  static Dio? _testDio;
  static List<InterceptorChainEntry> _interceptorChainSnapshot = const [];

  /// Snapshot of the active interceptor chain, in order. Populated the
  /// first time [instance] is read (i.e. when Dio is built).
  ///
  /// Consumers like `SystemDashboardCubit` should read this instead of
  /// hard-coding names — keeps the dashboard in sync with the chain  [dashboard 仪表盘]
  /// even when interceptors are added, removed, or conditionally
  /// included (e.g. [MockInterceptor] outside production).
  static List<InterceptorChainEntry> get interceptorChainSnapshot => List.unmodifiable(_interceptorChainSnapshot);

  /// Callback invoked when the session has expired (token refresh failed).
  ///
  /// Set this before the first API call (typically in app initialization) so
  /// that the [TokenRefreshInterceptor] can notify the app layer to log out.
  static OnSessionExpired? onSessionExpired;
}