import '../../../../core/security/security_utils.dart';
import '../../domain/entities/auth_entity.dart';
import '../models/jwt_token.dart';
import '../models/user_jwt.dart';

class AuthMapper {
  AuthMapper._();

  static UserJWT toUserJwt(AuthCredentialsEntity entity) {
    return UserJWT(entity.username, entity.password);
  }

  static AuthTokenEntity? toTokenEntity(JWTToken? model) {
    if (model == null) return null;

    DateTime? expiresAt;
    if (model.idToken != null) {
      expiresAt = SecurityUtils.getTokenExpiration(model.idToken!);
    }

    return AuthTokenEntity(idToken: model.idToken, refreshToken: model.refreshToken, expiresAt: expiresAt);
  }
}