import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_bloc_advanced/app/router/app_router.dart';
import 'package:my_bloc_advanced/app/router/app_routes_constants.dart';
import 'package:my_bloc_advanced/features/auth/application/login_bloc.dart';
import 'package:my_bloc_advanced/features/auth/application/usercases/authenticate_user_use_case.dart';
import 'package:my_bloc_advanced/features/auth/presentation/login_page.dart';
import 'package:my_bloc_advanced/l10n/app_localizations.dart';
import 'package:my_bloc_advanced/shared/design_system/theme/app_theme.dart';
import 'package:my_bloc_advanced/shared/design_system/theme/app_theme_palette.dart';

import 'app/di/app_dependencies.dart';
import 'app/session/session_cubit.dart';
import 'app/theme/theme_bloc.dart';
import 'core/logging/app_logger.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/navigation/auth_routes.dart';
import 'features/dashboard/navigation/dashboard_routes.dart';

void main() {
  runApp(MyApp(dependencies: AppDependencies()));
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
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(
              authenticateUserUseCase: AuthenticateUserUseCase(
                context.read<IAuthRepository>(),
              ),
            ),
          ),
          BlocProvider(create: (context) => SessionCubit()),
          BlocProvider<ThemeBloc>(
            create: (_) => ThemeBloc()..add(const LoadTheme()),
          ),
        ],
        child: _AppView(),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView({super.key});

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    _router ??= AppRouterFactory(
      sessionCubit: context.read<SessionCubit>(),
    ).create();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (BuildContext context, ThemeState themeState) => MaterialApp.router(
        theme: AppTheme.light(themeState.palette),
        darkTheme: AppTheme.dark(themeState.palette),
        themeMode: themeState.themeMode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // home: LoginScreen(),
        routerConfig: _router,
      ),
    );
  }
}
