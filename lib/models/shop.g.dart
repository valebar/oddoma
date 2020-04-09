// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return Shop(
    uid: json['uid'] as String,
    products: json['products'] as List,
    address: json['address'] as String,
    town: json['town'] as String,
    phone: json['phone'] as String,
    postCode: json['postCode'] as String,
    name: json['name'] as String,
    lat: (json['lat'] as num)?.toDouble(),
    lon: (json['lon'] as num)?.toDouble(),
    isVerified: json['isVerified'] as bool,
    email: json['email'] as String,
    description: json['description'] as String,
    delivery: json['delivery'] as String,
  );
}

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
      'uid': instance.uid,
      'products': instance.products,
      'address': instance.address,
      'town': instance.town,
      'phone': instance.phone,
      'postCode': instance.postCode,
      'name': instance.name,
      'email': instance.email,
      'lat': instance.lat,
      'lon': instance.lon,
      'isVerified': instance.isVerified,
      'description': instance.description,
      'delivery': instance.delivery,
    };
