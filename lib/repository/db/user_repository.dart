import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:oddoma/models/user.dart';
import 'package:geolocator/geolocator.dart';

class UserRepository {
  final userRef = Firestore.instance.collection('users');

  /// Funkcija, ki vrne user [User] iz firebase
  /// database (/user). Če je napaka, je user [null].
  Future<User> get(String uid) async {
    try {
      var querySnapshot =
          await userRef.where("id", isEqualTo: uid).getDocuments();
      var user = querySnapshot.documents == null
          ? null
          : querySnapshot.documents.isNotEmpty
              ? User.fromSnapshot(querySnapshot.documents[0])
              : null;
      return user;
    } catch (ex, s) {
      print(ex);
      print(s);
      return null;
    }
  }

  /// Ustvarjanje uprabnika. Če je vse ok,
  /// true, drugače false
  Future<bool> create(User user) async {
    final geolocator = Geolocator();
    List<Placemark> placemarks;
    try {
      placemarks = List.from(await geolocator
          .placemarkFromAddress(user.address + ", " + user.town));
    } catch (ex) {
      print(ex);
      return false;
    }
    user = user.copyWith(
      lat: placemarks[0].position.latitude,
      lon: placemarks[0].position.longitude,
    );

    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint myLocation =
        geo.point(latitude: user.lat, longitude: user.lon);

    try {
      var json = user.toJson();
      json['point'] = myLocation.data; //GeoPoint(user.lat, user.lon);
      await userRef.add(json);
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  /// Posodobitev uprabnika. Če je vse ok,
  /// true, drugače false
  Future<bool> update(User user) async {
    try {
      final geolocator = Geolocator();
      final List<Placemark> placemarks = await geolocator
          .placemarkFromAddress(user.address + ", " + user.town);
      user = user.copyWith(
        lat: placemarks[0].position.latitude,
        lon: placemarks[0].position.longitude,
      );

      Geoflutterfire geo = Geoflutterfire();
      GeoFirePoint myLocation =
          geo.point(latitude: user.lat, longitude: user.lon);

      try {
        var json = user.toJson();
        json['point'] = myLocation.data; //GeoPoint(user.lat, user.lon);
        await userRef.document(user.key).updateData(json);
        return true;
      } catch (ex) {
        print(ex);
        return false;
      }
    } catch (ex) {
      print(ex);
      return false;
    }
  }
}
