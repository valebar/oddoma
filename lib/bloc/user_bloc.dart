import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/repository/firebase_db_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository);

  @override
  UserState get initialState => UserInitial();

  @override
  void onTransition(Transition<UserEvent, UserState> transition) {
    print(transition);
  }

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserEventGetUser) {
      yield UserStateLoading();
      var user = await userRepository.get(event.user.id);
      if (user != null) {
        yield UserStateSuccess(user);
      } else {
        yield UserStateFailure('user == null');
      }
    }
    if (event is UserEventCreateUser) {
      yield UserStateLoading();
      var result = await userRepository.create(event.user);
      if (result != null) {
        if (result){
        yield UserStateSuccess(event.user);}
        else {
          yield UserStateFailure('Preveri uporabnikove podatke');
        }
      } else {
        yield UserStateFailure('user == null');
      }
    }
    if (event is UserEventUpdateUser) {
      yield UserStateLoading();
      var result = await userRepository.update(event.user);
      if (result != null) {
        yield UserStateUpdateSuccess(event.user);
      } else {
        yield UserStateUpdateFailure('user == null');
      }
    }
  }
}
