import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_advanced/demo/bloc/counter_cubit.dart';
import 'package:my_bloc_advanced/demo/bloc/counter_event.dart';
import 'package:my_bloc_advanced/demo/bloc/counter_state.dart';
import 'package:my_bloc_advanced/demo/bloc/couter_bloc.dart';

class Advancepage extends StatefulWidget {
  const Advancepage({super.key});

  @override
  State<Advancepage> createState() => _AdvancepageState();
}

class _AdvancepageState extends State<Advancepage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      _buildBody(context);
  }


  Scaffold _buildBody(BuildContext context) {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
        appBar: AppBar(title: Text("bloc进阶")),
        body: Column(
          children: [
            Row(
              children: [
                FilledButton(
                  onPressed: () {
                     // context.read<CounterBloc>().add(IncrementPressed());
                    // BlocProvider.of<CounterBloc>(context).add(IncrementPressed());
                    counterBloc.add(IncrementPressed());
                    context.read<CounterCubit>().incrementCount();
                  },
                  child: Text("++1"),
                ),
                BlocBuilder<CounterBloc, CounterState>(
                  builder: (BuildContext context,CounterState state) {
                    return Text('${state.count}');
                  },
                ),
                BlocBuilder<CounterCubit, int>(
                  builder: (BuildContext context,int state) {
                    return Text('${state}');
                  },
                ),
              ],
            ),
            // Row(
            //   children: [
            //     FilledButton(
            //       onPressed: () {
            //         context.read<CounterCubit>().incrementCount();
            //       },
            //       child: Text("+1"),
            //     ),
            //     BlocBuilder<CounterCubit, int>(
            //       builder: (context, state) {
            //         return Text("$state");
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      );
  }
}
