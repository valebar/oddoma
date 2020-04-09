import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/semantics.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/repository/firebase_db_repository.dart';
import 'package:oddoma/repository/firebase_auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthRepository authRepository;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final userRepo = UserRepository();

  AuthBloc(this.authRepository);

  @override
  AuthState get initialState => AuthInitial();

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    print(transition);
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthEventCheck) {
      yield AuthStateLoading();
      final isAuthenticated = await authRepository.isAutheniticated();
      if (!isAuthenticated) {
        yield AuthStateCheckFailed("user is not authenticated");
      } else {
        final user = await authRepository.getUser();
        yield AuthStateCheckSuccess(
          user,
        );
      }
    }
    if (event is AuthEventCheckEmailVerification) {
      yield AuthStateLoading();
      var fUser = await firebaseAuth.currentUser();
      if (fUser == null) {
        yield AuthStateEmailNotVerified();
      }
      await fUser.reload();
      if (fUser.isEmailVerified) {
        yield AuthStateEmailVerified();
      } else {
        yield AuthStateEmailNotVerified();
      }
    }
    if (event is AuthEventForgotEmail) {
      try {
        await firebaseAuth.sendPasswordResetEmail(email: event.email);
        yield AuthStateForgotEmailSuccess();
      } catch (ex) {
        yield AuthStateForgotEmailFailure();
      }
    }
  }
}
