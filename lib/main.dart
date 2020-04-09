import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oddoma/bloc/auth_bloc.dart';
import 'package:oddoma/bloc/login_bloc.dart';
import 'package:oddoma/bloc/logout_bloc.dart';
//import 'package:oddoma/bloc/register_bloc.dart';
import 'package:oddoma/bloc/shop_bloc.dart';
import 'package:oddoma/bloc/user_bloc.dart';
import 'package:oddoma/oddoma.dart';
import 'package:oddoma/repository/db/shop_repositoty.dart';
import 'package:oddoma/repository/firebase_auth_repository.dart';
import 'package:oddoma/repository/firebase_db_repository.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseAuthRepository =
      FirebaseAuthRepository(firebaseAuth: FirebaseAuth.instance);

  final firebaseAuth = FirebaseAuth.instance;
  final userRepo = UserRepository();
  final shopRepo = ShopRepositoty();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      child: OdDoma(),
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(firebaseAuthRepository),
        ),
        /* BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(firebaseAuth),
        ), */
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(firebaseAuth),
        ),
        BlocProvider<LogoutBloc>(
          create: (_) => LogoutBloc(firebaseAuth),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(userRepo),
        ),
        BlocProvider<ShopBloc>(
          create: (_) => ShopBloc(shopRepo),
        ),
      ],
    ),
  );
}
