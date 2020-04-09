import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shop.g.dart';

@JsonSerializable()
class Shop extends Equatable {
  @JsonKey(ignore: true)
  final String key;
  final String uid;
  final List products;
  final String address;
  final String town;
  final String phone;
  final String postCode;
  final String name;
  final String email;
  final double lat;
  final double lon;
  final bool isVerified;
  final String description;
  final String delivery;

  @override
  List<Object> get props => [
        key,
        uid,
        products,
        address,
        town,
        phone,
        postCode,
        name,
        email,
        lat,
        lon,
        isVerified,
        description,
        delivery
      ];

  Shop({
    this.key,
    this.uid,
    this.products,
    this.address,
    this.town,
    this.phone,
    this.postCode,
    this.name,
    this.lat,
    this.lon,
    this.isVerified,
    this.email,
    this.description,
    this.delivery,
  });

  Shop copyWith({
    String key,
    String uid,
    List products,
    String address,
    String town,
    String phone,
    String postCode,
    String name,
    double lat,
    double lon,
    bool isVerified,
    String email,
    String description,
    String delivery,
  }) {
    return Shop(
      key: key ?? this.key,
      address: address ?? this.address,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      postCode: postCode ?? this.postCode,
      products: products ?? this.products,
      town: town ?? this.town,
      uid: uid ?? this.uid,
      description: description ?? this.description,
      delivery: delivery ?? this.delivery,
    );
  }

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
  Map<String, dynamic> toJson() => _$ShopToJson(this);

  factory Shop.fromSnapshot(DocumentSnapshot snapshot) => Shop(
        key: snapshot.documentID,
        address: snapshot.data['address'],
        description: snapshot.data['description'],
        email: snapshot.data['email'],
        isVerified: snapshot.data['isVerified'],
        lat: snapshot.data['lat'],
        lon: snapshot.data['lon'],
        name: snapshot.data['name'],
        phone: snapshot.data['phone'],
        postCode: snapshot.data['postCode'],
        products: snapshot.data['products'],
        town: snapshot.data['town'],
        uid: snapshot.data['uid'],
        delivery: snapshot.data['delivery'],
      );
}
