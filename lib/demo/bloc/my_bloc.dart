import 'package:flutter_bloc/flutter_bloc.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  MeBloc() : super(MeLoading()) {
    on<LoadMe>((event, emit) async {
      emit(MeLoading());
      // emit(UserLoaded(
      //     List.of([User("tom", "yongzhou"), User("Jim", "guangzhou"),User("Jims", "guangzhou")])));

      try {
        // emit(UserLoaded(
        //     List.of([User("tom", "yongzhou"), User("Jim", "guangzhou")])));
        await Future.delayed(Duration(seconds: 2), () {
          emit(MeLoaded(Me("tom", "yongzhou")));
        });
      } catch (e) {
        emit(MeError("loading error"));
      }
    });
  }
}

abstract class MeState {}

class MeLoading extends MeState {}

class MeLoaded extends MeState {
  final Me me;

  MeLoaded(this.me);
}

class MeError extends MeState {
  final String message;

  MeError(this.message);
}

abstract class MeEvent {}

class LoadMe extends MeEvent {}

class Me {
  final String name;
  final String district;

  Me(this.name, this.district);
}
