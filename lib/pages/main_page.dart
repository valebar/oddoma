import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oddoma/bloc/shop_bloc.dart';
import 'package:oddoma/bloc/user_bloc.dart';
import 'package:oddoma/colors.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/pages/select_products.dart';
import 'package:oddoma/pages/settings/settings_page.dart';
import 'package:oddoma/pages/shop_page.dart';
import 'package:oddoma/pages/shops_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  final ScrollController scrollController = ScrollController();

  var radius = 20.0;
  var start = 0;
  var limit = 20;
  var filterByRadius = false;
  var filterByProducts = false;
  List<String> selectedProducts = List<String>();
  bool hideSearchButton = false;
  var user;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var fbUser = await FirebaseAuth.instance.currentUser();
    setState(() => user = User(id: fbUser.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        child: Drawer(
          child: Container(
            color: Color(0xFF303030),
            child: ListView(
              controller: scrollController,
              children: [
                ListTile(
                  title: Text(
                    "Moje stojnice".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: FaIcon(
                    FontAwesomeIcons.store,
                    color: Theme.of(context).accentColor,
                  ),
                  onTap: () async {
                    BlocProvider.of<ShopBloc>(context)
                        .add(ShopEventGetByUser(user));
                    Navigator.of(context).pop();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: RouteSettings(name: 'ShopsPage'),
                        builder: (_) => ShopsPage(user),
                      ),
                    );
                  },
                ),
                Divider(
                  color: Colors.white,
                ),
                ListTile(
                  title: Text(
                    "Nastavitve".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: FaIcon(
                    FontAwesomeIcons.cog,
                    color: Theme.of(context).accentColor,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SettingsPage(),
                        settings: RouteSettings(name: 'SettingsPage'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Lokalni ponudniki'.toUpperCase()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          hideSearchButton
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        child: RaisedButton(
                          child: Text("PONOVNO ISKANJE",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() => hideSearchButton = false);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          /* topLeft: Radius.circular(10),
                    topRight: Radius.circular(10), */
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "Iskanje po oddaljenosti",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.dotCircle,
                                      color: filterByRadius
                                          ? Theme.of(context).accentColor
                                          : Colors.white,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      setState(() =>
                                          filterByRadius = !filterByRadius);
                                    },
                                  )
                                  /* Checkbox(
                            value: filterByRadius,
                            onChanged: (r) =>
                                setState(() => filterByRadius = r),
                          ), */
                                  ),
                            ],
                          ),
                          filterByRadius
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: FlutterSlider(
                                    trackBar: FlutterSliderTrackBar(
                                      activeTrackBar: BoxDecoration(
                                          color: Theme.of(context).accentColor),
                                      inactiveTrackBar: BoxDecoration(
                                        color: Theme.of(context)
                                            .accentColor
                                            .withAlpha(100),
                                      ),
                                    ),
                                    tooltip: FlutterSliderTooltip(
                                      disabled: true,
                                    ),
                                    handlerWidth: 50,
                                    handlerHeight: 30,
                                    handler: FlutterSliderHandler(
                                      child: Text(
                                          radius.toInt().toString() + "km"),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    values: [radius],
                                    max: 100,
                                    min: 0,
                                    axis: Axis.horizontal,
                                    onDragging:
                                        (handlerIndex, lowerValue, upperValue) {
                                      setState(() {
                                        radius = lowerValue;
                                      });
                                    },
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.shoppingBasket,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "Iskanje po dobrinah",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.dotCircle,
                                      color: filterByProducts
                                          ? Theme.of(context).accentColor
                                          : Colors.white,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      setState(() =>
                                          filterByProducts = !filterByProducts);
                                    },
                                  ) /* Checkbox(
                            value: filterByProducts,
                            onChanged: (v) =>
                                setState(() => filterByProducts = v),
                          ), */
                                  ),
                            ],
                          ),
                          filterByProducts
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 20,
                                    top: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 30,
                                        child: RaisedButton(
                                          color: Theme.of(context).accentColor,
                                          onPressed: () async {
                                            var products =
                                                await Navigator.of(context)
                                                    .push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    SelectProductsPage(
                                                  selectedProducts,
                                                  isSearch: true,
                                                ),
                                                settings: RouteSettings(
                                                    name: 'SelectProductsPage'),
                                              ),
                                            );
                                            if (products != null) {
                                              setState(() =>
                                                  selectedProducts = products);
                                            }
                                          },
                                          child: Text(
                                            "Spisek dobrin".toUpperCase(),
                                            style: TextStyle(
                                                color: Colors
                                                    .white), //style: TextStyle(color: Theme.of(context).backgroundColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : Container(),
                          filterByProducts
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: selectedProducts
                                        .map(
                                          (e) => InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Theme.of(context)
                                                        .accentColor),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Wrap(
                                                  children: <Widget>[
                                                    Text(e,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .solidTimesCircle,
                                                      size: 15,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                selectedProducts.remove(e);
                                              });
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: RaisedButton(
                        //color: Theme.of(context).accentColor,
                        child: Text(
                          "Išči".toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          setState(() => hideSearchButton = true);
                          /* var fbUser =
                              await FirebaseAuth.instance.currentUser(); */
                          BlocProvider.of<UserBloc>(context).add(
                              UserEventGetUser(
                                  user /* User(id: fbUser.uid) */));
                          //User user;
                          int r;
                          List<String> products;
                          await for (var state
                              in BlocProvider.of<UserBloc>(context)) {
                            if (state is UserStateSuccess) {
                              setState(() => user = state.user);
                              break;
                            }
                            if (state is UserStateFailure) {
                              break;
                            }
                          }
                          if (user == null) {
                            return;
                          }
                          if (filterByRadius) {
                            r = radius.toInt();
                          } else {
                            user = null;
                            r = null;
                          }
                          if (filterByProducts) {
                            products = List.from(selectedProducts);
                          } else {
                            products = null;
                          }
                          BlocProvider.of<ShopBloc>(context).add(
                            ShopEventGetByQuery(
                              user: user,
                              radius: r == null ? null : r.toDouble(),
                              products: products,
                              start: 0,
                              length: limit,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
          SizedBox(
            height: 10,
          ),
          BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              if (state is ShopStateLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ShopStateSearchSuccess) {
                var shops = state.shops;
                if (shops.isEmpty) {
                  return Text("Ni iskanih ponudnikov.");
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: shops.length,
                    itemBuilder: (context, idx) {
                      var prods = List.from(selectedProducts);
                      prods.removeWhere(
                          (element) => shops[idx].products.contains(element));
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: idx == 0
                                    ? BorderSide(
                                        width: 1,
                                        color: lightGray,
                                      )
                                    : BorderSide(
                                        width: 0,
                                        color: Colors.transparent,
                                      ),
                                bottom: BorderSide(
                                  color: lightGray,
                                  width: 1,
                                ),
                              ),
                              color: idx % 2 == 0
                                  ? Colors.transparent
                                  : Theme.of(context).accentColor.withAlpha(30),
                            ),
                            child: ListTile(
                              isThreeLine: true,
                              dense: true,
                              title: Text(
                                shops[idx].name,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    shops[idx].description,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  filterByProducts
                                      ? Text(prods.join(','),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough))
                                      : Container(),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  shops[idx].phone != null
                                      ? IconButton(
                                          // telefon
                                          color:
                                              Theme.of(context).backgroundColor,
                                          onPressed: () async {
                                            analytics.logEvent(
                                                name:
                                                    "list -> phoneButton -> onPressed");
                                            var num = 'tel:' +
                                                shops[idx].phone.replaceAll(
                                                    RegExp(r'\s+\b|\b\s|\s|\b'),
                                                    '');
                                            if (await canLaunch(num)) {
                                              await launch(num);
                                            }
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.phoneAlt,
                                            color: Theme.of(context)
                                                .backgroundColor,
                                            size: 15,
                                          ),
                                        )
                                      : Container(),
                                  IconButton(
                                    // email
                                    color: Theme.of(context).backgroundColor,
                                    onPressed: () async {
                                      analytics.logEvent(
                                          name:
                                              "list -> emailButton -> onPressed");
                                      var m = 'mailto:' + shops[idx].email;
                                      if (await canLaunch(m)) {
                                        await launch(m);
                                      }
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.envelope,
                                      color: Theme.of(context).backgroundColor,
                                      size: 15,
                                    ),
                                    //label: Container() //Text("EMAIL"),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ShopPage(shops[idx], edit: false),
                                    settings: RouteSettings(name: 'ShopPage'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
