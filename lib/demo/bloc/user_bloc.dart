import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent,UserState>{

  UserBloc():super(UserLoading()){
    on<LoadUser>((event,emit) async {
      emit(UserLoading());
      // emit(UserLoaded(
      //     List.of([User("tom", "yongzhou"), User("Jim", "guangzhou"),User("Jims", "guangzhou")])));

      try {
        // emit(UserLoaded(
        //     List.of([User("tom", "yongzhou"), User("Jim", "guangzhou")])));
       await Future.delayed(Duration(seconds: 2),(){
         emit(UserLoaded(
             List.of([User("tom", "yongzhou"), User("Jim", "guangzhou")])));
       });
      }catch(e){
        emit(UserError("loading error"));
      }
    });
  }
}

abstract class UserState{}

class UserLoading extends UserState{
}

class UserLoaded extends UserState{
  final List<User> users;
  UserLoaded(this.users);
}

class UserError extends UserState{
  final String message;

  UserError(this.message);
}

abstract class UserEvent{}

class LoadUser extends UserEvent{}

class User {
  final String name;
  final String district;

  User(this.name, this.district);
}

