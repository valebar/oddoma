import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(ignore: true)
  final String key;
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String postCode;
  final String phoneNumber;
  final String address;
  final String town;
  @JsonKey(ignore: true)
  final String password;
  @JsonKey(ignore: true)
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final double lat;
  final double lon;

  @override
  List<Object> get props => [
        key,
        id,
        email,
        firstName,
        lastName,
        postCode,
        town,
        phoneNumber,
        address,
        password,
        isEmailVerified,
        isPhoneVerified,
        lat,
        lon,
      ];

  User({
    this.key,
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.postCode,
    this.phoneNumber,
    this.town,
    this.address,
    this.password,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.lat,
    this.lon,
  });

  User copyWith({
    String key,
    String id,
    String email,
    String firstName,
    String lastName,
    String town,
    String postCode,
    String phoneNumber,
    String address,
    String password,
    bool isEmailVerified,
    bool isPhoneVerified,
    double lat,
    double lon,
  }) =>
      User(
        key: key ?? this.key,
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        town: town ?? this.town,
        postCode: postCode ?? this.postCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        password: password ?? this.password,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User.fromSnapshot(DocumentSnapshot snapshot)
      : key = snapshot.documentID,
        id = snapshot.data['id'],
        email = snapshot.data['email'],
        firstName = snapshot.data['firstName'],
        lastName = snapshot.data['lastName'],
        town = snapshot.data['town'],
        postCode = snapshot.data['postCode'],
        phoneNumber = snapshot.data['phoneNumber'],
        address = snapshot.data['address'],
        isPhoneVerified =
            snapshot.data['isPhoneVerified'],
        password = null,
        isEmailVerified = null,
        lat = snapshot.data['lat'],
        lon = snapshot.data['lon'];
}
