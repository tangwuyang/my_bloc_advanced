import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int>{
  CounterCubit():super(0);

  void incrementCount(){
    state + 1;
    emit(state+1);
  }

}