import '../../../../core/result/result.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthenticateUserUseCase {
  final IAuthRepository _repository;
  const AuthenticateUserUseCase(this._repository);

  Future<Result<AuthTokenEntity>> call(AuthCredentialsEntity credentials) {
    return _repository.authenticate(credentials);
  }
}