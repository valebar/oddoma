import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/models/shop.dart';

class ShopRepositoty {
  final shopsRef = Firestore.instance.collection('/shops');
  final productsRef = Firestore.instance.collection('/products');

  Future<List<Shop>> getUserShops(User user) async {
    try {
      var output = List<Shop>();
      var shops =
          await shopsRef.where('uid', isEqualTo: user.id).getDocuments();
      shops.documents.forEach((element) {
        output.add(Shop.fromSnapshot(element));
      });
      return output;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  /* Query _queryProducts(List<String> prods, Shop lastShop, int limit) {
    Query q = productsRef.where('product', whereIn: prods);
    if (limit != null) {
      if (lastShop == null) {
        return q.limit(limit);
      } else {
        return q.startAfter([lastShop.key]);
      }
    } else {
      return q;
    }
  }

  _queryLocation(
      double r, /* double lat, double lon,  */ User user, Query ref) async {
    final geolocator = Geolocator();
    final List<Placemark> placemarks = await geolocator.placemarkFromAddress(
      user.address + ", " + user.town,
    );
    final geo = Geoflutterfire();
    GeoFirePoint center = geo.point(
      latitude: placemarks[0].position.latitude,
      longitude: placemarks[0].position.longitude,
    );
    try {
      return await geo
          .collection(collectionRef: ref)
          .within(center: center, radius: r, field: 'point', strictMode: true)
          .first;
    } catch (ex, s) {
      print(ex);
      print(s);
      return null;
    }
  }

  Future<List<Shop>> getShopsByQuery({
    User user,
    double r,
    List<String> products,
    Shop lastShop,
    int limit,
  }) async {
    Query query;
    List<Shop> output;

    if (products != null) {
      if (products.isNotEmpty) {
        query = _queryProducts(products, lastShop, limit);
      }
    }
    if (user != null && r != null) {
      if (query != null) {
        var localOutput;
        var q = _queryLocation(r, user, query);
        await for (var o in q) {
          localOutput = o;
          break;
        }
        print(localOutput);
      }
    }
  } */

  Future<List<Shop>> getShopsByQuery({
    User user,
    double r,
    List<String> products,
  }) async {
    try {
      final output = <Shop>[];
      final isGeospatialQuery = (user != null && r != null);
      final isProductsQuery = products.isNotEmpty;

      Query query;

      try {
        if (isProductsQuery) {
          query = productsRef.where('product', whereIn: products);
        }
      } catch (ex) {
        print(ex);
      }

      if (isGeospatialQuery) {
        final geolocator = Geolocator();
        final List<Placemark> placemarks =
            await geolocator.placemarkFromAddress(
          user.address + ", " + user.town,
        );
        final geo = Geoflutterfire();
        GeoFirePoint center = geo.point(
          latitude: placemarks[0].position.latitude,
          longitude: placemarks[0].position.longitude,
        );
        if (isProductsQuery) {
          var geoStream = geo
              .collection(
                collectionRef: shopsRef.reference(),
              )
              .within(
                center: center,
                radius: r,
                field: 'point',
                strictMode: true,
              );
          await for (var ss in geoStream.cast()) {
            for (var s in ss) {
              var locS = Shop.fromSnapshot(s);
              bool containsProduct = false;
              for (var product in products) {
                if (locS.products.contains(product)) {
                  containsProduct = true;
                  break;
                }
              }
              if (containsProduct) {
                output.add(locS);
              }
            }
            break;
          }
          return output;
        } else {
          var geoStream = geo
              .collection(
                collectionRef: shopsRef.reference(),
              )
              .within(
                center: center,
                radius: r,
                field: 'point',
                strictMode: true,
              );

          await for (var s in geoStream.cast()) {
            for (var ss in s) {
              output.add(Shop.fromSnapshot(ss));
            }
            break;
          }
          return output;
        }
      } else if (isProductsQuery) {
        var docs = await query.getDocuments();
        docs.documents.forEach((element) {
          var shop = Shop.fromSnapshot(element);
          shop = shop.copyWith(key: element.data['key']);
          if (!output.contains(shop)) {
            output.add(shop);
          }
        });
        return output;
      } else {
        var data = (await shopsRef.getDocuments()).documents;
        data.forEach((element) {
          var shop = Shop.fromSnapshot(element);
          shop = shop.copyWith(key: element.data['key']);
          if (!output.contains(shop)) {
            output.add(Shop.fromSnapshot(element));
          }
        });
        return output;
      }
    } catch (ex) {
      print(ex);
      return <Shop>[];
    }
  }

  Future<bool> create({User user, Shop shop}) async {
    final geolocator = Geolocator();
    final List<Placemark> placemarks =
        await geolocator.placemarkFromAddress(shop.address + ", " + shop.town);
    shop = shop.copyWith(
      lat: placemarks[0].position.latitude,
      lon: placemarks[0].position.longitude,
      uid: user.id,
    );
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint myLocation =
        geo.point(latitude: shop.lat, longitude: shop.lon);
    try {
      var json = shop.toJson();
      json['point'] = myLocation.data; //GeoPoint(shop.lat, shop.lon);
      var ref = await shopsRef.add(json);
      for (var product in shop.products) {
        json['product'] = product;
        json['key'] = ref.documentID;
        productsRef.document().setData(json);
      }
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> update({Shop oldShop, Shop newShop}) async {
    try {
      (await productsRef.where('key', isEqualTo: oldShop.key).getDocuments())
          .documents
          .forEach((element) {
        element.reference.delete();
      });

      final geolocator = Geolocator();
      final List<Placemark> placemarks = await geolocator
          .placemarkFromAddress(newShop.address + ", " + newShop.town);
      newShop = newShop.copyWith(
        lat: placemarks[0].position.latitude,
        lon: placemarks[0].position.longitude,
      );
      Geoflutterfire geo = Geoflutterfire();
      GeoFirePoint myLocation =
          geo.point(latitude: newShop.lat, longitude: newShop.lon);
      var json = newShop.toJson();
      json['point'] = myLocation.data;
      await shopsRef.document(newShop.key).updateData(json);
      for (var product in newShop.products) {
        json['product'] = product;
        json['key'] = oldShop.key;
        productsRef.document().setData(json);
      }
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> deleteShop(Shop shop) async {
    try {
      (await productsRef.where('key', isEqualTo: shop.key).getDocuments())
          .documents
          .forEach((element) {
        element.reference.delete();
      });
      await shopsRef.document(shop.key).delete();
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }
}
