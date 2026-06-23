import 'package:my_bloc_advanced/core/result/result.dart';
import 'package:my_bloc_advanced/features/auth/domain/entities/auth_entity.dart';
import 'package:my_bloc_advanced/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/errors/app_api_exception.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../infrastructure/http/api_client.dart';
import '../mapper/auth_mapper.dart';
import '../models/jwt_token.dart';

class LoginRepository implements IAuthRepository{
  static final _log = AppLogger.getLogger("LoginRepository");
  LoginRepository();

  @override
  Future<Result<AuthTokenEntity>> authenticate(AuthCredentialsEntity userJWT) async{
    try{
      if(userJWT.username.isEmpty || userJWT.password.isEmpty){
        return const Failure(ValidationError("Invalid username or password"));
      }

      final request = AuthMapper.toUserJwt(userJWT);

      final response = await ApiClient.post("/authenticate", request);
      final result = JWTToken.fromJsonString(response.data!);
      _log.debug("END:authenticate successful - response.body: {}", [result.toString()]);
      final entity = AuthMapper.toTokenEntity(result);
      if (entity == null) {
        return const Failure(UnknownError("Failed to parse authentication token"));
      }
      return Success(entity);
    }on UnauthorizedException catch (e) {
      _log.error("END:authenticate auth error: {}", [e.toString()]);
      return Failure(AuthError(e.toString()));
    } on BadRequestException catch (e) {
      _log.error("END:authenticate validation error: {}", [e.toString()]);
      return Failure(ValidationError(e.toString()));
    } on FetchDataException catch (e) {
      _log.error("END:authenticate network error: {}", [e.toString()]);
      return Failure(_mapFetchDataException(e));
    } catch (e, st) {
      _log.error("END:authenticate error: {}", [e.toString()]);
      return Failure(UnknownError(e.toString()), stackTrace: st);
    }
  }

  static AppError _mapFetchDataException(FetchDataException e) {
    final message = e.toString().toLowerCase();
    if (message.contains('timeout')) return TimeoutError(e.toString());
    return NetworkError(e.toString());
  }
}