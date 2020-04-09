import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:oddoma/models/shop.dart';
import 'package:oddoma/models/user.dart';
import 'package:oddoma/repository/db/shop_repositoty.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepositoty shopRep;

  ShopBloc(this.shopRep);

  @override
  ShopState get initialState => ShopInitial();

  @override
  void onTransition(Transition<ShopEvent, ShopState> transition) {
    print(transition);
  }

  @override
  Stream<ShopState> mapEventToState(
    ShopEvent event,
  ) async* {
    if (event is ShopEventCreate) {
      yield ShopStateLoading();
      final isCreated = await shopRep.create(
          user: User(id: event.shop.uid), shop: event.shop);
      if (isCreated) {
        yield ShopStateSuccess(shop: event.shop);
      } else {
        yield ShopStateFailure(error: 'shop creation failed', shop: event.shop);
      }
    }
    if (event is ShopEventUpdate) {
      yield ShopStateLoading();
      final isUpdated =
          await shopRep.update(newShop: event.shop, oldShop: event.oldShop);
      if (isUpdated) {
        yield ShopStateSuccess(shop: event.shop);
      } else {
        yield ShopStateFailure(error: 'shop creation failed', shop: event.shop);
      }
    }
    if (event is ShopEventDelete) {}
    if (event is ShopEventGetByQuery) {
      yield ShopStateLoading();

      final shops = await shopRep.getShopsByQuery(
        user: event.user,
        r: event.radius,
        products: event.products ?? <String>[],
      );
      if (shops != null) {
        yield ShopStateSearchSuccess(shops: shops);
      } else {
        yield ShopStateSearchFailure(
            error: 'failed retrieving shops by distance', shop: null);
      }
    }
    if (event is ShopEventGetByUser) {
      yield ShopStateLoading();
      final shops = await shopRep.getUserShops(event.user);
      if (shops != null) {
        yield ShopStateSuccess(shops: shops);
      } else {
        yield ShopStateFailure(
            error: 'error retrieving user shops', shop: null);
      }
    }
    if (event is ShopEventDelete) {
      yield ShopStateLoading();
      var result = await shopRep.deleteShop(event.shop);
      if (result == true) {
        var shops = List<Shop>.from(event.shops);
        shops.remove(event.shop);
        yield ShopStateSuccess(shop: event.shop, shops: shops);
      } else {
        yield ShopStateFailure(error: "Error removing shop", shop: event.shop);
      }
    }
  }
}
