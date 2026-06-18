import 'package:dio/dio.dart';

/// Backend contract for the refresh endpoint, isolated as named
/// constants so a typo or rename surfaces at one site instead of
/// scattering across the file. Not exported (private to this library)
/// because they describe how *this* interceptor talks to the backend —
/// not a project-wide HTTP policy.
class _RefreshEndpoint {
  static const path = '/api/token/refresh';
  static const requestKeyRefreshToken = 'refresh_token';
  static const responseKeyIdToken = 'id_token';
  static const responseKeyRefreshToken = 'refresh_token';
}

/// HTTP auth header shape. Same locality reasoning as
/// [_RefreshEndpoint] — these are how this layer writes the header,
/// not a cross-feature contract.
class _AuthHeader {
  static const name = 'Authorization';
  static const bearerPrefix = 'Bearer ';
}

/// Callback signature for notifying the app layer that the session has expired
/// and the user must be logged out.
///
/// By using a callback we avoid importing anything from `app/` in the
/// infrastructure layer.
typedef OnSessionExpired = void Function();

/// Factory for the bare [Dio] instance used to POST the refresh
/// request. A separate Dio is needed so the refresh call bypasses the
/// production interceptor chain (otherwise a 401 on `/api/token/refresh`
/// would re-enter this interceptor recursively). Pluggable so tests
/// can short-circuit the POST without depending on `http_mock_adapter`.
typedef RefreshDioFactory = Dio Function(Dio sourceDio);