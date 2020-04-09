import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oddoma/bloc/auth_bloc.dart';
import 'package:oddoma/bloc/login_bloc.dart';
//import 'package:oddoma/bloc/register_bloc.dart';
import 'package:oddoma/bloc/user_bloc.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/pages/auth/auth_page.dart';
import 'package:oddoma/pages/auth/email_verification_page.dart';
import 'package:oddoma/pages/main_page.dart';
import 'package:oddoma/pages/settings/user_page.dart';

final authListeners = [
  BlocListener<UserBloc, UserState>(
    listener: (context, state) async {
      if (state is UserStateSuccess) {
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MainPage(),
          ),
          (route) => false,
        );
      }
      if (state is UserStateFailure) {
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => UserPage()),
          (route) => false,
        );
      }
    },
  ),
  BlocListener<AuthBloc, AuthState>(
    listener: (context, state) async {
      if (state is AuthStateCheckFailed) {
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => AuthPage(),
          ),
          (route) => false,
        );
      }
      if (state is AuthStateCheckSuccess) {
        BlocProvider.of<AuthBloc>(context)
            .add(AuthEventCheckEmailVerification());
      }
      if (state is AuthStateEmailNotVerified) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => EmailVerificationPage()),
            (route) => false);
      }
      if (state is AuthStateEmailVerified) {
        var fUser = await FirebaseAuth.instance.currentUser();

        BlocProvider.of<UserBloc>(context).add(
          UserEventGetUser(
            User(
              id: fUser.uid,
            ),
          ),
        );
        /* Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => MainPage()), (route) => false); */
      }
    },
  ),
  BlocListener<LoginBloc, LoginState>(
    listener: (context, state) {
      if (state is LoginStateSuccess) {
        BlocProvider.of<UserBloc>(context).add(UserEventGetUser(state.user));
      }
      if (state is LoginStateFailed) {
        /* BlocProvider.of<RegisterBloc>(context)
            .add(RegisterEventEmail(state.user)); */
      }
    },
  ),
];
