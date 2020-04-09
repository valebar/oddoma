// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    postCode: json['postCode'] as String,
    phoneNumber: json['phoneNumber'] as String,
    town: json['town'] as String,
    address: json['address'] as String,
    isPhoneVerified: json['isPhoneVerified'] as bool,
    lat: (json['lat'] as num)?.toDouble(),
    lon: (json['lon'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'postCode': instance.postCode,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'town': instance.town,
      'isPhoneVerified': instance.isPhoneVerified,
      'lat': instance.lat,
      'lon': instance.lon,
    };
