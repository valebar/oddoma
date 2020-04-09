import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oddoma/bloc/auth_bloc.dart';
import 'package:oddoma/bloc_listeners/auth_listeners.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then(
        (value) => BlocProvider.of<AuthBloc>(context).add(AuthEventCheck()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: authListeners,
      child: Scaffold(
        backgroundColor: Color(0xff21252d),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/png/loading_center.png",
                width: MediaQuery.of(context).size.width / 2,
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
