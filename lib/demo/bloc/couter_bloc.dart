import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_advanced/demo/bloc/counter_event.dart';
import 'package:my_bloc_advanced/demo/bloc/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent,CounterState>{
  CounterBloc(): super(CounterState(0)){
    on<IncrementPressed>((event,emit){
      print('---------------receive');
     emit(CounterState(state.count+1));
    });
  }
}