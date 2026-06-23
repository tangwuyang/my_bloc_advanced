import 'package:my_bloc_advanced/features/auth/domain/entities/auth_entity.dart';
import '../../../../core/result/result.dart';

abstract class IAuthRepository{
  Future<Result<AuthTokenEntity>> authenticate(AuthCredentialsEntity userJWT);
}