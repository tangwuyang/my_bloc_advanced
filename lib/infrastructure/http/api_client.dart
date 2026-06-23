
import 'package:dio/dio.dart';

import '../../core/errors/app_api_exception.dart';
import '../../core/logging/app_logger.dart';
import 'interceptors/mock_interceptor.dart';
import 'interceptors/token_refresh_interceptor.dart';

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

  /// The active Dio instance.
  static Dio get instance {
    if (_testDio != null) return _testDio!;
    return _dio ??= _createDio();
  }

  static Dio _createDio(){

    final dio = Dio(
      BaseOptions(
        baseUrl:  '',
        connectTimeout: const Duration(seconds: _timeoutSeconds),
        receiveTimeout: const Duration(seconds: _timeoutSeconds),
        responseType: ResponseType.plain,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      ),
    );

    final chain = <({Interceptor interceptor, InterceptorChainEntry meta})>[
      (
      interceptor: MockInterceptor(),
      meta: const InterceptorChainEntry(
        name: 'MockInterceptor',
        active: false,
        detail: 'Serves mock data in dev/test',
      ),
      )
    ];
    dio.interceptors.addAll(chain.map((e) => e.interceptor));
    return dio;
  }



  static Future<Response<String>> post<T>(
      String path,
      T data, {
        Map<String, String>? headers,
        String? contentType,
        String? pathParams,
      }) async {
    final fullPath = pathParams != null ? '$path/$pathParams' : path;
    final serialized = _serializeData(data);
    final options = Options(
      extra: {'_basePath': path, '_pathParams': pathParams},
      headers: headers,
      contentType: contentType,
    );
    try {
      return await instance.post<String>(fullPath, data: serialized, options: options);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Error mapping — converts DioException to AppException hierarchy
  // ---------------------------------------------------------------------------

  static AppException _mapDioException(DioException e) {
    // If the wrapped error is already an AppException (e.g. from MockInterceptor),
    // unwrap and rethrow it directly.
    if (e.error is AppException) return e.error as AppException;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return FetchDataException('TimeoutException');
      case DioExceptionType.connectionError:
        return FetchDataException('No Internet connection');
      case DioExceptionType.badResponse:
        return _mapBadResponse(e);
      case DioExceptionType.cancel:
        return FetchDataException('Request cancelled');
      case DioExceptionType.badCertificate:
        return FetchDataException('Bad certificate');
      case DioExceptionType.unknown:
        return _mapUnknown(e);
    }
  }

  static AppException _mapBadResponse(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final body = e.response?.data?.toString() ?? '';
    switch (statusCode) {
      case 400:
        return BadRequestException(body);
      case 401:
        return UnauthorizedException(body);
      case 403:
        return UnauthorizedException(body);
      case 404:
        return FetchDataException('Not found: $body');
      case >= 500:
        return FetchDataException('Server error ($statusCode): $body');
      default:
        return FetchDataException('HTTP $statusCode: $body');
    }
  }

  static AppException _mapUnknown(DioException e) {
    final message = e.error?.toString() ?? e.message ?? 'Unknown error';
    if (message.contains('SocketException')) return FetchDataException('No Internet connection');
    if (message.contains('Timeout') || message.contains('timeout')) return FetchDataException('TimeoutException');
    return FetchDataException(message);
  }

  /// Serialize [data] for Dio: Maps/Strings/Lists pass through; objects call `toJson()`.
  static dynamic _serializeData<T>(T data) {
    if (data is Map || data is String || data is List) return data;
    return (data as dynamic).toJson();
  }

}