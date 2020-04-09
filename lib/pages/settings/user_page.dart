import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oddoma/bloc/user_bloc.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/pages/shop_page.dart';

class UserPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final User user;

  UserPage({this.user});

  @override
  Widget build(BuildContext context) {
    User newUser;
    if (user == null) {
      FirebaseAuth.instance.currentUser().then((value) {
        emailController.text = value.email;
        newUser = User(email: value.email, id: value.uid);
      });
    } else {
      newUser = user.copyWith();
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      townController.text = user.town;
      addressController.text = user.address;
      postCodeController.text = user.postCode;
      phoneNumberController.text = user.phoneNumber;
    }
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => ShopPage(
                null,
                isSignIn: true,
              ),
            ),
            (route) => false,
          );
        }
        if (state is UserStateUpdateSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: user == null
              ? Text("Registracija".toUpperCase())
              : Text("Profil".toUpperCase()),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          autovalidate: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: TextFormField(
                    enabled: false,
                    controller: emailController,
                    autovalidate: false,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      if (val == "") {
                        return "Polje imena ne sme biti prazno";
                      }
                      return null;
                    },
                    controller: firstNameController,
                    autovalidate: false,
                    decoration: InputDecoration(
                      labelText: "Ime",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      if (val == "") {
                        return "Polje priimka ne sme biti prazno";
                      }
                      return null;
                    },
                    controller: lastNameController,
                    autovalidate: false,
                    decoration: InputDecoration(
                      labelText: "Priimek",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      if (val == "") {
                        return "Polje naslova ne sme biti prazno";
                      }
                      return null;
                    },
                    controller: addressController,
                    autovalidate: false,
                    decoration: InputDecoration(
                      labelText: "Naslov",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      if (val == "") {
                        return "Polje kraja ne sme biti prazno";
                      }
                      return null;
                    },
                    controller: townController,
                    autovalidate: false,
                    decoration: InputDecoration(
                      labelText: "Kraj",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "Polje poštne številke ne sme biti prazno ne sme biti prazno";
                      }
                      return null;
                    },
                    controller: postCodeController,
                    autovalidate: false,
                    keyboardType: TextInputType.numberWithOptions(
                      signed: true,
                      decimal: false,
                    ),
                    decoration: InputDecoration(
                      labelText: "Poštna številka",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneNumberController,
                    autovalidate: false,
                    decoration: InputDecoration(
                      labelText: "Telefonska številka",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserStateFailure) {
                      if (user == null && state.failure == "user == null") {
                        return Container();
                      } else {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: Center(
                            child: Text(
                              state.failure,
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            ),
                          ),
                        );
                      }
                    }
                    return Container();
                  },
                ),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: RaisedButton(
                        child: state is UserStateLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator())
                            : user == null
                                ? Text(
                                    "Registracija".toUpperCase(),
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "Posodobitev".toUpperCase(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                        onPressed: state is UserStateLoading
                            ? null
                            : () {
                                if (!formKey.currentState.validate()) {
                                  return;
                                }

                                newUser = newUser.copyWith(
                                  address: addressController.text,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  phoneNumber: phoneNumberController.text == ""
                                      ? null
                                      : phoneNumberController.text,
                                  postCode: postCodeController.text,
                                  town: townController.text,
                                );
                                if (user == null) {
                                  BlocProvider.of<UserBloc>(context).add(
                                    UserEventCreateUser(newUser),
                                  );
                                } else {
                                  BlocProvider.of<UserBloc>(context).add(
                                    UserEventUpdateUser(newUser),
                                  );
                                }
                              },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
