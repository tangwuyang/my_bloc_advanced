import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_advanced/core/security/security_utils.dart';

import '../../core/logging/app_logger.dart';
import '../../infrastructure/storage/secure_storage.dart';

class SessionCubit extends Cubit<SessionState> {

  static final _log = AppLogger.getLogger('SessionCubit');

  SessionCubit(super.initialState, {ISecureStorage? secureStorage})
      :_secureStorage = secureStorage ?? FlutterSecureStorageAdapter();

  final ISecureStorage _secureStorage;

  Future<void> restore() async {
    // ISecureStorage.read can throw on platform / decryption failure.
    // restore() is invoked fire-and-forget from BlocProvider, so any
    // escaping exception becomes an unhandled async error. Wrap the
    // read + decision in try/catch and treat any failure as
    // unauthenticated — the safe default that forces a fresh login
    // rather than leaving the cubit in `unknown` forever.
    try {
      final token = await _secureStorage.read(SecureStorageKeys.jwtToken.key);
      final hasToken = SecurityUtils.hasToken(token);
      if (!hasToken) {
        _log.info('restore: no token in secure storage → unauthenticated');
        emit(const SessionUnauthenticated(reason: SessionExpiredReason.noToken));
        // In production we additionally reject expired tokens. In non-prod
        // (mocks/dev) we stay lenient so a static MOCK_TOKEN without an
        // `exp` claim does not log the user out on every restart.
        // if (ProfileConstants.isProduction) {
        if (false) {  //是否是生产环境 逻辑后续添加
          final expired = SecurityUtils.isTokenExpired(token);
          _log.info('restore: token found, expired={} → authenticated={}', [expired, !expired]);
          if (expired) {
            emit(const SessionUnauthenticated(reason: SessionExpiredReason.expired));
          } else {
            emit(const SessionAuthenticated());
          }
        } else {
          _log.info('restore: token found (dev/test lenient) → authenticated');
          emit(const SessionAuthenticated());
        }
      }
    }catch (e, st) {
      _log.error('restore: secure storage read failed → unauthenticated (safe default): {}\n{}', [e, st]);
      emit(const SessionUnauthenticated(reason: SessionExpiredReason.storageError));
    }
  }
}

class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => const [];
}

/// Initial state, before [SessionCubit.restore] has completed.
///
/// The router treats this the same as [SessionUnauthenticated] for
/// redirect decisions (we cannot route into protected routes without
/// proof of session), but consumers that need to discriminate — e.g.
/// a splash screen — can pattern-match on the type rather than relying
/// on convention.
final class SessionUnknown extends SessionState {
  const SessionUnknown();
}

/// User holds a valid session token in secure storage.
final class SessionAuthenticated extends SessionState {
  const SessionAuthenticated();
}

/// User holds no valid session token. The [reason] is for logs and
/// tests — it MUST NOT be surfaced to the user as a localized error
/// because the categories are deliberately coarse.
final class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated({this.reason = SessionExpiredReason.unknown});

  final SessionExpiredReason reason;

  @override
  List<Object?> get props => [reason];
}

/// Why the cubit emitted [SessionUnauthenticated]. Drives log fidelity
/// and lets tests assert specific failure pathways without coupling
/// them to log strings.
enum SessionExpiredReason {
  /// No token in secure storage (clean logged-out state).
  noToken,

  /// Token present but past its `exp` claim.
  expired,

  /// Secure storage read threw (platform / decryption failure).
  /// We fall back to unauthenticated as the safe default so the user
  /// re-authenticates cleanly instead of leaving the cubit in
  /// [SessionUnknown] forever.
  storageError,

  /// Initial or otherwise uncategorized — e.g. an explicit logout
  /// flow that does not need to distinguish further.
  unknown,
}
