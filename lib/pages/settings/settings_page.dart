import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oddoma/pages/settings/logout_page.dart';
import 'package:oddoma/pages/settings/user_page.dart';
import 'package:oddoma/repository/db/user_repository.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nastavitve".toUpperCase()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            dense: false,
            title: Text('Urejanje profila'.toUpperCase()),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              var fbUser = await FirebaseAuth.instance.currentUser();
              var u = await UserRepository().get(fbUser.uid);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UserPage(
                    user: u,
                  ),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            dense: false,
            title: Text(
              'Izpis iz aplikacije'.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).errorColor,
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => LogoutPage()));
            },
          ),
        ],
      ),
    );
  }
}
