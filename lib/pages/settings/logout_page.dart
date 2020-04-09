import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oddoma/bloc/logout_bloc.dart';
import 'package:oddoma/pages/auth/auth_page.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutStateSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => AuthPage()), (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Izpis iz aplikacije".toUpperCase()),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Prosim, potrdi izpis iz aplikacije!"),
              SizedBox(height: 10),
              RaisedButton(
                color: Colors.red[500],
                child: Text(
                  "Potrjujem".toUpperCase(),
                ),
                onPressed: () {
                  BlocProvider.of<LogoutBloc>(context)
                      .add(LogoutEventConfirm());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
