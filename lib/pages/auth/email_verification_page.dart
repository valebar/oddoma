import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oddoma/bloc/auth_bloc.dart';
import 'package:oddoma/bloc/user_bloc.dart';
import 'package:oddoma/main.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/pages/auth/auth_page.dart';
import 'package:oddoma/pages/settings/user_page.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with TickerProviderStateMixin {
  String email = "";
  AnimationController _controller;
  bool isAway = false;

  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(
      AuthEventCheckEmailVerification(),
    );
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.forward();

    FirebaseAuth.instance.currentUser().then(
          (value) => setState(() => email = value.email),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserStateFailure) {
              navigatorKey.currentState.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => UserPage()),
                  (route) => false);
            }
            if (state is UserStateSuccess) {
              navigatorKey.currentState.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => UserPage()),
                  (route) => false);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(listener: (context, state) async {
          if (state is AuthStateEmailNotVerified) {
            Future.delayed(
              Duration(seconds: 5),
              () {
                if (!isAway) {
                  BlocProvider.of<AuthBloc>(context).add(
                    AuthEventCheckEmailVerification(),
                  );
                }
              },
            );
          }
          if (state is AuthStateEmailVerified) {
            final user = await FirebaseAuth.instance.currentUser();
            BlocProvider.of<UserBloc>(context).add(
              UserEventGetUser(User(id: user.uid)),
            );
          }
        })
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //CircularProgressIndicator(),
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                child: Image.asset(
                  "assets/png/auth_page.png",
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  "Prosim, če odgovorite na verifikacijsko sporočilo,ki smo vam ga poslali na $email.",
                  style: TextStyle(
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                child: RaisedButton(
                  color: Theme.of(context).backgroundColor,
                  child: Text("PONOVNO POŠLJI EMAIL",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    var user = await FirebaseAuth.instance.currentUser();
                    user.sendEmailVerification();
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                child: RaisedButton(
                  child: Text(
                    "SPREMENI EMAIL NASLOV",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() => isAway = true);
                    navigatorKey.currentState.pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => AuthPage(), maintainState: false),
                        (route) => false);
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Počakajte trenutek!",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text("Aplikacija se bo po verifikaciji osvežila samodejno!")
            ],
          ),
        ),
      ),
    );
  }
}
