import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantMenuViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  final String restaurantId;

  RestaurantMenuViewModel({this.restaurantId});

  ScrollController scrollController = new ScrollController();

  List<MenuItem> _menuItems;
  List<MenuItem> get menuItems => _menuItems;

  Stream<List<MenuItem>> listenToPosts() {
    Stream<List<MenuItem>> stream;
    if (restaurantId != null) {
      stream = _firestoreService.listenToMenuItemsRealTime(
        restaurantId,
      );
    } else {
      stream = _firestoreService.listenToMenuItemsRealTime(
        _authenticationService.userRestaurant.id,
      );
    }

    return stream;
  }

  void setMenuItemType(int index, int scrollPoint) {
    scrollController.animateTo(
      (scrollPoint * 167 + index * 44).toDouble(),
      curve: Curves.ease,
      duration: Duration(milliseconds: 300),
    );
  }
}
