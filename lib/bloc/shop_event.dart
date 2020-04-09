part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();
}

class ShopEventGetByUser extends ShopEvent {
  final User user;

  ShopEventGetByUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'ShopEventGetByUser';
}

class ShopEventGetByQuery extends ShopEvent {
  final User user;
  final double radius;
  final List<String> products;
  final int start;
  final int length;

  ShopEventGetByQuery({
    this.user,
    this.radius,
    this.products,
    @required this.length,
    @required this.start,
  });

  @override
  List<Object> get props => [user, radius, products, start, length];

  @override
  String toString() => 'ShopEventGetByQuery: $start, $length';
}

class ShopEventCreate extends ShopEvent {
  final Shop shop;

  ShopEventCreate(this.shop);

  @override
  List<Object> get props => [shop];

  @override
  String toString() => 'ShopEventCreate';
}

class ShopEventUpdate extends ShopEvent {
  final Shop oldShop;
  final Shop shop;

  ShopEventUpdate({this.oldShop, this.shop});

  @override
  List<Object> get props => [shop, oldShop];

  @override
  String toString() => 'ShopEventUpdate';
}

class ShopEventDelete extends ShopEvent {
  final Shop shop;
  final List<Shop> shops;

  ShopEventDelete({this.shop, this.shops});

  @override
  List<Object> get props => [shop, shops];

  @override
  String toString() => 'ShopEventDelete';
}
