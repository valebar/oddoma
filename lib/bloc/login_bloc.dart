import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oddoma/models/user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth firebaseAuth;

  LoginBloc(this.firebaseAuth);

  @override
  LoginState get initialState => LoginInitial();

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    print(transition);
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginEventEmail) {
      yield LoginStateLoading();
      try {
        var authResult = await firebaseAuth.signInWithEmailAndPassword(
            email: event.user.email, password: event.user.password);

        if (authResult == null) {
          authResult = await firebaseAuth.createUserWithEmailAndPassword(
              email: event.user.email, password: event.user.password);
          authResult.user.sendEmailVerification();
          yield LoginStateSuccess(
            event.user.copyWith(
              id: authResult.user.uid,
            ),
          );
        } else {
          yield LoginStateSuccess(
            event.user.copyWith(
              id: authResult.user.uid,
            ),
          );
        }
      } catch (ex) {
        print(ex);
        try {
          var authResult = await firebaseAuth.createUserWithEmailAndPassword(
              email: event.user.email, password: event.user.password);
          authResult.user.sendEmailVerification();
          yield LoginStateSuccess(
            event.user.copyWith(
              id: authResult.user.uid,
            ),
          );
        } catch (ex) {
          print(ex);
          yield LoginStateFailed(event.user, "login user: failed");
        }
        //yield LoginStateFailed(event.user, "login user: failed");
      }
    }
  }
}
