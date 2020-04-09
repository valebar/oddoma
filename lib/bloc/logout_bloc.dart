import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oddoma/models/user.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final FirebaseAuth firebaseAuth;

  LogoutBloc(this.firebaseAuth);

  @override
  LogoutState get initialState => LogoutInitial();

  @override
  void onTransition(Transition<LogoutEvent, LogoutState> transition) {
    print(transition);
  }

  @override
  Stream<LogoutState> mapEventToState(
    LogoutEvent event,
  ) async* {
    if (event is LogoutEventConfirm) {
      yield LogoutStateLoading();
      try {
        await firebaseAuth.signOut();
        yield LogoutStateSuccess();
      } catch (ex) {
        print(ex);
        yield LogoutStateFailed("logout user: failed");
      }
    }
  }
}
