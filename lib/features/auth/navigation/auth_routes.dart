
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_bloc_advanced/features/auth/presentation/login_page.dart';

import '../../../app/router/app_routes_constants.dart';

class AuthFeatureRoutes {
  static List<GoRoute> publicRoutes({
    Widget Function(BuildContext context)? loginBuilder,
  }) => [
    GoRoute(
      name: 'login',
      path: ApplicationRoutesConstants.login,
      builder: (context, state) =>
          loginBuilder?.call(context) ?? const LoginScreen(),
    ),
  ];
}
