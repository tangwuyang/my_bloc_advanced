import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_advanced/features/auth/application/login_bloc.dart';
import 'package:my_bloc_advanced/features/auth/presentation/login_page.dart';
import 'package:my_bloc_advanced/l10n/app_localizations.dart';
import 'package:my_bloc_advanced/shared/design_system/theme/app_theme.dart';
import 'package:my_bloc_advanced/shared/design_system/theme/app_theme_palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>LoginBloc())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: AppTheme.light(AppThemePalette.classic),
        darkTheme: AppTheme.dark(AppThemePalette.classic),
        home: LoginScreen(),
      ),
    );
  }
}