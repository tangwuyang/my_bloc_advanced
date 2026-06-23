import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_advanced/features/auth/application/login_bloc.dart';
import 'package:my_bloc_advanced/features/auth/application/usercases/authenticate_user_use_case.dart';
import 'package:my_bloc_advanced/features/auth/presentation/login_page.dart';
import 'package:my_bloc_advanced/l10n/app_localizations.dart';
import 'package:my_bloc_advanced/shared/design_system/theme/app_theme.dart';
import 'package:my_bloc_advanced/shared/design_system/theme/app_theme_palette.dart';

import 'app/di/app_dependencies.dart';
import 'core/logging/app_logger.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

void main() {
  runApp(MyApp(dependencies: AppDependencies(),));
}

class MyApp extends StatelessWidget {
   const MyApp({super.key, required this.dependencies});
   final AppDependencies dependencies;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppLogger.configure(isProduction: false);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IAuthRepository>(
          create: (context) => dependencies.createAuthRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=>LoginBloc(authenticateUserUseCase: AuthenticateUserUseCase(context.read<IAuthRepository>())))
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppTheme.light(AppThemePalette.classic),
          darkTheme: AppTheme.dark(AppThemePalette.classic),
          home: LoginScreen(),
        ),
      ),
    );
  }
}