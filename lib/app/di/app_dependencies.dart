import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

class AppDependencies {

  IAuthRepository createAuthRepository() => LoginRepository();

  AppDependencies();
}