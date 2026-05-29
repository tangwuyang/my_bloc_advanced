import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_advanced/demo/bloc/counter_cubit.dart';
import 'package:my_bloc_advanced/demo/bloc/counter_event.dart';
import 'package:my_bloc_advanced/demo/bloc/counter_state.dart';
import 'package:my_bloc_advanced/demo/bloc/couter_bloc.dart';
import 'package:my_bloc_advanced/demo/bloc/my_bloc.dart';
import 'package:my_bloc_advanced/demo/bloc/user_bloc.dart';
import 'package:my_bloc_advanced/features/auth/presentation/login_page.dart';
import 'package:my_bloc_advanced/generated/l10n.dart';
import 'package:my_bloc_advanced/l10n/app_localizations.dart';
import 'package:my_bloc_advanced/shared/design_system/theme/app_theme.dart';
import 'package:my_bloc_advanced/shared/design_system/theme/app_theme_palette.dart';

import 'AdvancePage.dart';

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
        BlocProvider(create: (context) => CounterBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => MeBloc()),
        BlocProvider(create: (context) => CounterCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: AppTheme.light(AppThemePalette.classic),
        darkTheme: AppTheme.dark(AppThemePalette.classic),
        home: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(LoadUser());
    return Column(
      children: [
        FilledButton(
          onPressed: () {
            context.read<CounterBloc>().add(IncrementPressed());
          },
          child: Text("+1"),
        ),
        BlocBuilder<CounterBloc, CounterState>(
          buildWhen: (p, c) {
            return c.count % 2 == 0;
          },
          builder: (BuildContext context, CounterState state) {
            return Text('${state.count}');
          },
        ),


        // FilledButton(onPressed: (){
        //   context.read<UserBloc>().add(LoadUser());
        // }, child: Text("查询所有用户")),
        BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            if (state is UserLoading) return LinearProgressIndicator();
            if (state is UserLoaded) return Text("${state.users.length}个用户");
            if (state is UserError) return Text(state.message);
            return SizedBox();
          },
        ),

        FilledButton(onPressed: (){
          context.read<MeBloc>().add(LoadMe());
        }, child: Text("加载我的信息")),
        BlocSelector<MeBloc, MeState,String>(
          selector: (state) {
            if(state is MeLoaded) return state.me.name;
            return "不知道";
          },
          builder: (BuildContext context, String state) {
           return Text(state);
            return SizedBox();
          },
        ),

        FilledButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return
              Advancepage();
              // BlocProvider( create: (context) => CounterBloc(),child: Advancepage());
          }));
        }, child: Text("进阶")),
      ],
    );
  }
}
