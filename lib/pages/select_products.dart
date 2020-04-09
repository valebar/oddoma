import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oddoma/models/products.dart';

class SelectProductsPage extends StatefulWidget {
  final List<String> selectedProducts;
  final bool isSearch;

  SelectProductsPage(this.selectedProducts, {@required this.isSearch});

  @override
  _SelectProductsPageState createState() => _SelectProductsPageState();
}

class _SelectProductsPageState extends State<SelectProductsPage> {
  List<String> selectedProducts;
  List<String> products;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    selectedProducts = widget.selectedProducts;
    allProducts.sort((a, b) => a.compareTo(b));
    products = List.from(allProducts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dobrine".toUpperCase()),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
          child: Container(
            width: MediaQuery.of(context).size.width - 80,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).backgroundColor,
                width: 1.4,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  40,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.search,
                    color: Theme.of(context).backgroundColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Išči po dobrinah"),
                      onChanged: (s) {
                        var result = allProducts
                            .where((element) =>
                                element.toLowerCase().contains(s.toLowerCase()))
                            .toList();
                        setState(() => products = result);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 80,
          child: RaisedButton(
            onPressed: () {
              Navigator.of(context).pop(selectedProducts);
            },
            child: Text(
              "Shrani".toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        widget.isSearch ? Text("Izbereš lahko največ 6 dobrin") : Container(),
        SizedBox(
          height: 20,
        ),
        Expanded(
            child: ListTileTheme(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, idx) {
              TextStyle style;
              if (selectedProducts.contains(products[idx])) {
                style = TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20);
              } else {
                style = TextStyle();
              }
              return ListTile(
                title: Center(
                  child: Text(
                    products[idx],
                    style: style,
                  ),
                ),
                dense: true,
                onTap: () {
                  if (selectedProducts.contains(products[idx])) {
                    setState(() {
                      selectedProducts.remove(products[idx]);
                    });
                  } else {
                    if (widget.isSearch) {
                      if (selectedProducts.length < 6) {
                        setState(() {
                          selectedProducts.add(products[idx]);
                        });
                      }
                    } else {
                      setState(() {
                        selectedProducts.add(products[idx]);
                      });
                    }
                  }
                  setState(() => controller.text = "");
                },
              );
            },
          ),
        ))
      ]),
    );
  }
}
