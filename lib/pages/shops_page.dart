import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oddoma/bloc/shop_bloc.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/pages/shop_page.dart';

class ShopsPage extends StatelessWidget {
  final User user;
  ShopsPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stojnice".toUpperCase()),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text(
                  "Dodaj novo stojnico".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  var result = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ShopPage(null, isSignIn: false,)));
                  if (result != null) {
                    BlocProvider.of<ShopBloc>(context)
                        .add(ShopEventGetByUser(user));
                  }
                },
              )
            ],
          ),
          BlocBuilder<ShopBloc, ShopState>(
            bloc: BlocProvider.of<ShopBloc>(context),
            builder: (context, state) {
              if (state is ShopStateLoading) {
                return CircularProgressIndicator();
              }
              if (state is ShopStateSuccess) {
                if (state.shops != null) {
                  var shops = state.shops;
                  if (shops.isEmpty) {
                    return Container();
                  }
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: shops.length,
                      itemBuilder: (context, idx) {
                        return ListTile(
                          title: Text(shops[idx].name),
                          subtitle: Text(shops[idx].description),
                          onTap: () async {
                            var result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ShopPage(
                                  shops[idx],
                                ),
                              ),
                            );
                            if (result != null) {
                              BlocProvider.of<ShopBloc>(context)
                                  .add(ShopEventGetByUser(user));
                            }
                          },
                          trailing: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.trashAlt,
                              color: Theme.of(context).backgroundColor,
                            ),
                            onPressed: () {
                              BlocProvider.of<ShopBloc>(context).add(
                                  ShopEventDelete(
                                      shop: shops[idx], shops: shops));
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
