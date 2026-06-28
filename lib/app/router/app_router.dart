import 'package:go_router/go_router.dart';

import '../../features/auth/navigation/auth_routes.dart';
import '../../features/dashboard/navigation/dashboard_routes.dart';
import '../session/session_cubit.dart';
import 'app_routes_constants.dart';

class AppRouterFactory {
  final SessionCubit _sessionCubit;

  AppRouterFactory({required SessionCubit sessionCubit}) : _sessionCubit = sessionCubit;

  GoRouter create(){
    return GoRouter( initialLocation: ApplicationRoutesConstants.home,
        routes: [
          // ShellRoute(routes: [...DashboardFeatureRoutes.routes]),
          ...DashboardFeatureRoutes.routes,
          ...AuthFeatureRoutes.publicRoutes(),
        ],
        redirect:(context,state){
          final location = state.uri.path;

          final sessionState  = _sessionCubit.state;
          final isAuthenticated = sessionState is SessionAuthenticated;
          if(isAuthenticated) return ApplicationRoutesConstants.home;
          else return ApplicationRoutesConstants.login;
        });
  }
}