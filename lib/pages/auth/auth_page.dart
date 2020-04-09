import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oddoma/bloc/auth_bloc.dart';
import 'package:oddoma/bloc/login_bloc.dart';
import 'package:oddoma/bloc/user_bloc.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/pages/auth/email_verification_page.dart';
import 'package:oddoma/pages/main_page.dart';
import 'package:oddoma/pages/settings/user_page.dart';
import 'package:flutter/services.dart';
import 'package:oddoma/validators/email_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginStateSuccess) {
              BlocProvider.of<AuthBloc>(context)
                  .add(AuthEventCheckEmailVerification());
            }
            if (state is LoginStateFailed) {
              /* BlocProvider.of<RegisterBloc>(context)
                  .add(RegisterEventEmail(state.user)); */
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserStateSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => MainPage()),
                  (route) => false);
            }
            if (state is UserStateFailure) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => UserPage()),
                  (route) => false);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthStateCheckFailed) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => EmailVerificationPage()),
                  (route) => false);
            }
            if (state is AuthStateCheckSuccess) {
              BlocProvider.of<UserBloc>(context).add(
                UserEventGetUser(
                  User(id: state.user.id),
                ),
              );
            }
            if (state is AuthStateEmailNotVerified) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => EmailVerificationPage()),
                  (route) => false);
            }
            if (state is AuthStateEmailVerified) {
              final fu = await FirebaseAuth.instance.currentUser();
              BlocProvider.of<UserBloc>(context).add(
                UserEventGetUser(
                  User(id: fu.uid),
                ),
              );
            }
          },
        )
      ],
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: TextFormField(
                  autovalidate: false,
                  validator: (email) {
                    if (!isEmail(email)) {
                      return "Napaka v email naslovu";
                    }
                    return null;
                  },
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: FaIcon(FontAwesomeIcons.user,
                        color: Theme.of(context).accentColor),
                    border: InputBorder.none,
                    labelText: "Email",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Container(height: 1, color: Colors.black26),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: TextFormField(
                  autovalidate: false,
                  validator: (password) {
                    if (password.length < 6) {
                      return "Geslo naj vsebuje vsaj 6 znakov";
                    }
                    return null;
                  },
                  controller: passwordTextEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: FaIcon(
                      FontAwesomeIcons.lock,
                      color: Theme.of(context).accentColor,
                    ),
                    labelText: "Geslo",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Container(height: 1, color: Colors.black26),
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) => Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: RaisedButton(
                    child: state is LoginStateLoading
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            'Vpiši se'.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                    onPressed: state is LoginStateLoading
                        ? null
                        : isAgreed
                            ? () {
                                if (formKey.currentState.validate()) {
                                  BlocProvider.of<LoginBloc>(context).add(
                                    LoginEventEmail(
                                      User(
                                          email:
                                              emailTextEditingController.text,
                                          password:
                                              passwordTextEditingController
                                                  .text),
                                    ),
                                  );
                                }
                              }
                            : null,
                  ),
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) => Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Column(
                    children: [
                      state is AuthStateForgotEmailSuccess
                          ? Text("Na emailu imate navodilo za novo geslo!")
                          : Container(),
                      state is AuthStateForgotEmailFailure
                          ? Text("Uporabnik ni registran / email je napačen")
                          : Container(),
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: RaisedButton(
                          color: Theme.of(context).backgroundColor,
                          child: state is AuthStateForgotEmailLoading
                              ? CircularProgressIndicator()
                              : Text("Pozabil sem geslo".toUpperCase()),
                          onPressed: state is AuthStateForgotEmailLoading
                              ? null
                              : () {
                                  BlocProvider.of<AuthBloc>(context).add(
                                      AuthEventForgotEmail(
                                          emailTextEditingController.text));
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Preberi si pogoje o zasebnosti"),
                        onPressed: () async {
                          final url = 'http://oddoma.si/privacy_policy.html';
                          if (await canLaunch(url)) {
                            launch(url);
                          }
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: isAgreed,
                          onChanged: (v) => setState(() => isAgreed = v),
                        ),
                        Text(
                          "Strinjam se s pogoji o zasebnosti",
                          style: TextStyle(
                            color: !isAgreed
                                ? Theme.of(context).errorColor
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                      top: 20,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constrains) {
                        return Image.asset(
                          "assets/png/auth_page.png",
                          width: constrains.maxWidth - 200,
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
