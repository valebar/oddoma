part of 'shop_bloc.dart';

abstract class ShopState extends Equatable {
  const ShopState();
}

class ShopInitial extends ShopState {
  @override
  List<Object> get props => [];
}

class ShopStateLoading extends ShopState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ShopStateLoading';
}

class ShopStateSuccess extends ShopState {
  final Shop shop;
  final List<Shop> shops;

  ShopStateSuccess({this.shop, this.shops});

  @override
  List<Object> get props => [shop, shops];

  @override
  String toString() => 'ShopStateSuccess';
}

class ShopStateFailure extends ShopState {
  final String error;
  final Shop shop;

  ShopStateFailure({@required this.error, @required this.shop});

  @override
  List<Object> get props => [error, shop];

  @override
  String toString() => 'ShopStateFailure';
}

class ShopStateSearchSuccess extends ShopState {
  final Shop shop;
  final List<Shop> shops;

  ShopStateSearchSuccess({this.shop, this.shops});

  @override
  List<Object> get props => [shop, shops];

  @override
  String toString() => 'ShopStateSearchSuccess';
}

class ShopStateSearchFailure extends ShopState {
  final String error;
  final Shop shop;

  ShopStateSearchFailure({@required this.error, @required this.shop});

  @override
  List<Object> get props => [error, shop];

  @override
  String toString() => 'ShopStateFailure';
}
