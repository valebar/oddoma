import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oddoma/bloc/shop_bloc.dart';
import 'package:oddoma/bloc/user_bloc.dart';
import 'package:oddoma/models/shop.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/pages/main_page.dart';
import 'package:oddoma/pages/select_products.dart';
import 'package:oddoma/validators/email_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopPage extends StatefulWidget {
  final Shop shop;
  final bool edit;
  final bool isSignIn;

  ShopPage(this.shop, {this.edit = true, this.isSignIn = false});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController townController = TextEditingController();

  final TextEditingController postCodeController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  bool useUserData = false;

  String uid;
  String productsError;
  var delivery = <String>[];
  //String delivery = "Dogovor";
  //final List<String> deliveryList = ['Dostava', 'Prevzem', 'Dogovor'];
  bool edit = true;

  List<String> selectedProducts = List<String>();
  //Map<String, bool> selectedProducts = Map<String, bool>();
  List<Widget> productTokens = List<Widget>();

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((value) => uid = value.uid);

    if (widget.shop != null) {
      nameController.text = widget.shop.name;
      descriptionController.text = widget.shop.description;
      emailController.text = widget.shop.email;
      addressController.text = widget.shop.address;
      townController.text = widget.shop.town;
      postCodeController.text = widget.shop.postCode;
      phoneController.text = widget.shop.phone;
      selectedProducts = List.from(widget.shop.products);
      //delivery = widget.shop.delivery;
      delivery = widget.shop.delivery.split(',');
    }
    edit = widget.edit;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stojnica".toUpperCase()),
        centerTitle: true,
        actions: <Widget>[
          widget.isSignIn
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: RaisedButton(
                        color: Color(0xff21252d),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => MainPage()),
                              (route) => false);
                        },
                        child: Text(
                          "Preskoči".toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              : Container()
        ],
      ),
      body: Form(
        key: formKey,
        autovalidate: false,
        child: Column(
          children: <Widget>[
            edit
                ? Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xff21252d),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.user,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Uporabi osebne podatke",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: Checkbox(
                            value: useUserData,
                            onChanged: checkBoxChange,
                            checkColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  TextFormField(
                    enabled: edit,
                    validator: stringValidator,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Ime stojnice",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  TextFormField(
                    enabled: edit,
                    validator: stringValidator,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Opis stojnice",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    maxLines: 100,
                    minLines: 3,
                  ),
                  TextFormField(
                    validator: (v) {
                      if (isEmail(v)) {
                        return null;
                      } else {
                        return "Email ni pravilne oblike";
                      }
                    },
                    readOnly: !edit,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      suffix: !edit
                          ? IconButton(
                              icon: FaIcon(FontAwesomeIcons.solidEnvelopeOpen),
                              onPressed: () async {
                                if (await canLaunch(
                                    'mailto:${emailController.text}')) {
                                  await launch(
                                      'mailto:${emailController.text}');
                                }
                              })
                          : Text(""),
                    ),
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    enabled: edit,
                    validator: stringValidator,
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: "Naslov",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    enabled: edit,
                    validator: stringValidator,
                    controller: townController,
                    decoration: InputDecoration(
                      labelText: "Mesto",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.numberWithOptions(
                      signed: true,
                      decimal: false,
                    ),
                    enabled: edit,
                    validator: stringValidator,
                    controller: postCodeController,
                    decoration: InputDecoration(
                      labelText: "Poštna številka",
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  TextFormField(
                    //enabled: edit,
                    readOnly: !edit,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: InputDecoration(
                        labelText: "Telefonska številka",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        suffix: !edit
                            ? IconButton(
                                icon: FaIcon(FontAwesomeIcons.phoneAlt),
                                onPressed: () async {
                                  if (phoneController.text == "") {
                                    return;
                                  }
                                  var num = 'tel:' +
                                      phoneController.text.replaceAll(
                                          RegExp(r'\s+\b|\b\s|\s|\b'), '');
                                  if (await canLaunch(num)) {
                                    await launch(num);
                                  }
                                },
                              )
                            : Text("")),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: edit
                              //? () => setState(() => delivery = 'Dostava')
                              ? () {
                                  if (delivery.contains('Dostava')) {
                                    setState(() {
                                      delivery.remove('Dostava');
                                    });
                                  } else {
                                    {
                                      setState(() {
                                        delivery.add('Dostava');
                                      });
                                    }
                                  }
                                }
                              : null,
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 40) / 3,
                            decoration: BoxDecoration(
                              color: !delivery.contains(
                                      'Dostava') //delivery != 'Dostava'
                                  ? Colors.black
                                  : Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Dostava'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: edit
                              //? () =>
                              //    setState(() => delivery = 'Prevzemno mesto')
                              ? () {
                                  if (delivery.contains('Prevzemno mesto')) {
                                    setState(() {
                                      delivery.remove('Prevzemno mesto');
                                    });
                                  } else {
                                    setState(() {
                                      delivery.add('Prevzemno mesto');
                                    });
                                  }
                                }
                              : null,
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 40) / 3,
                            decoration: BoxDecoration(
                              color: !delivery.contains(
                                      'Prevzemno mesto') //delivery != 'Prevzemno mesto'
                                  ? Colors.black
                                  : Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Prevzemno mesto'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: edit
                              //? () => setState(() => delivery = 'Dogovor')
                              ? () {
                                  if (delivery.contains('Dogovor')) {
                                    setState(() {
                                      delivery.remove('Dogovor');
                                    });
                                  } else {
                                    setState(() {
                                      delivery.add('Dogovor');
                                    });
                                  }
                                }
                              : null,
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 40) / 3,
                            decoration: BoxDecoration(
                              color: !delivery.contains(
                                      'Dogovor') //delivery != 'Dogovor'
                                  ? Colors.black
                                  : Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Dogovor'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  selectedProducts.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 5,
                            runSpacing: 5,
                            children: selectedProducts
                                .map(
                                  (s) => InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context).accentColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Wrap(
                                          children: <Widget>[
                                            Text(s),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            FaIcon(
                                              FontAwesomeIcons.solidTimesCircle,
                                              size: 15,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: edit
                                        ? () {
                                            setState(() {
                                              selectedProducts.remove(s);
                                            });
                                          }
                                        : () {},
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      : Container(),
                  edit
                      ? RaisedButton(
                          color: Colors.black,
                          child: Text(
                            "Uredi dobrine".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            var products = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => SelectProductsPage(
                                          selectedProducts,
                                          isSearch: !widget.edit,
                                        )));
                            if (products != null) {
                              setState(() {
                                selectedProducts = products;
                                productsError = null;
                              });
                            }
                          },
                        )
                      : Container(),
                  productsError == null
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              productsError,
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  edit
                      ? RaisedButton(
                          //color: Colors.blue,
                          child: Text(
                            widget.shop == null
                                ? "Shrani".toUpperCase()
                                : "Posodobi".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (!formKey.currentState.validate()) {
                              return;
                            }
                            if (selectedProducts.isEmpty) {
                              setState(() {
                                productsError = "Izbrati moraš vsaj en produkt";
                              });
                              return;
                            }
                            if (widget.shop == null) {
                              BlocProvider.of<ShopBloc>(context).add(
                                ShopEventCreate(
                                  Shop(
                                    address: addressController.text,
                                    delivery: delivery.join(','),
                                    description: descriptionController.text,
                                    email: emailController.text,
                                    name: nameController.text,
                                    phone: phoneController.text == ""
                                        ? null
                                        : phoneController.text,
                                    postCode: postCodeController.text,
                                    products: selectedProducts,
                                    town: townController.text,
                                    uid: uid,
                                  ),
                                ),
                              );
                              if (widget.isSignIn) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => MainPage()),
                                  (route) => false,
                                );
                              } else {
                                Navigator.of(context).pop(true);
                              }
                            } else {
                              BlocProvider.of<ShopBloc>(context).add(
                                ShopEventUpdate(
                                  oldShop: widget.shop,
                                  shop: Shop(
                                    key: widget.shop.key,
                                    address: addressController.text,
                                    delivery: delivery.join(','),
                                    description: descriptionController.text,
                                    email: emailController.text,
                                    name: nameController.text,
                                    phone: phoneController.text == ""
                                        ? null
                                        : phoneController.text,
                                    postCode: postCodeController.text,
                                    products: selectedProducts,
                                    town: townController.text,
                                    uid: uid,
                                  ),
                                ),
                              );
                              Navigator.of(context).pop(true);
                            }
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkBoxChange(v) async {
    setState(() {
      useUserData = v;
    });
    if (v) {
      BlocProvider.of<UserBloc>(context).add(
        UserEventGetUser(
          User(id: uid),
        ),
      );
      await for (var state in BlocProvider.of<UserBloc>(context)) {
        if (state is UserStateSuccess) {
          emailController.text = state.user.email;
          phoneController.text = state.user.phoneNumber;
          postCodeController.text = state.user.postCode;
          townController.text = state.user.town;
          addressController.text = state.user.address;
          break;
        }
        if (state is UserStateFailure) {
          break;
        }
      }
    }
  }

  String stringValidator(str) {
    if (str == null) {
      return "Polje ne sme biti prazno";
    }
    if (str == "") {
      return "Polje ne sme biti prazno";
    }
    return null;
  }
}
