import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantMenuViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final String restaurantId;

  RestaurantMenuViewModel({this.restaurantId});

  ScrollController scrollController = new ScrollController();

  List<MenuItem> _menuItems;
  List<MenuItem> get menuItems => _menuItems;

  List<String> _carMenuItemIds = [];
  List<String> get cartMenuItemIds => _carMenuItemIds;

  int _total = 0;
  int get total => _total;

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

  void orderMenuItems(String reservationId) async {
    await _firestoreService.orderMenuItems(
      _carMenuItemIds,
      _total,
      reservationId,
    );
    _navigationService.pop();
  }

  void setMenuItemType(int index, int scrollPoint) {
    scrollController.animateTo(
      (scrollPoint * 167 + index * 44).toDouble(),
      curve: Curves.ease,
      duration: Duration(milliseconds: 300),
    );
  }

  void addToCart(MenuItem menuItem) {
    _carMenuItemIds.add(menuItem.id);
    _total += menuItem.price;
    notifyListeners();
  }

  void removeFromCart(MenuItem menuItem) {
    if (_carMenuItemIds.contains(menuItem.id)) {
      _carMenuItemIds.remove(menuItem.id);
      _total -= menuItem.price;
      notifyListeners();
    }
  }

  int getQuantity(String menuItemId) {
    var foundElements = _carMenuItemIds.where((e) => e == menuItemId);
    return foundElements.length;
  }
}
