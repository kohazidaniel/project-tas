import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/models/order_item.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/models/tas_notification.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:uuid/uuid.dart';

class RestaurantMenuViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final String restaurantId;
  final String reservationId;

  RestaurantMenuViewModel({this.restaurantId, this.reservationId});

  ScrollController scrollController = new ScrollController();

  List<MenuItem> _menuItems;
  List<MenuItem> get menuItems => _menuItems;

  List<OrderItem> _orders = [];
  List<OrderItem> get orders => _orders;

  int _total = 0;
  int get total => _total;

  Stream<List<MenuItem>> listenToMenuItems() {
    if (restaurantId != null) {
      return _firestoreService.listenToMenuItems(
        restaurantId,
      );
    } else {
      return _firestoreService.listenToMenuItems(
        _authenticationService.userRestaurant.id,
      );
    }
  }

  void orderMenuItems() async {
    Restaurant restaurant = await _firestoreService.getRestaurantById(
      restaurantId,
    );

    await _firestoreService.sendNotification(
      TasNotification(
        id: Uuid().v1(),
        content:
            '${_authenticationService.currentUser.fullName} rendelést adott le',
        navigationId: reservationId,
        navigationRoute: RestaurantReservationViewRoute,
        seen: false,
        userId: restaurantId,
        createDate: Timestamp.now(),
      ),
      restaurant.fcmToken,
    );

    await _firestoreService.orderMenuItems(
      _orders,
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
    int index = _orders.indexWhere((order) => order.menuItem.id == menuItem.id);

    if (index >= 0) {
      _orders[index].quantity += 1;
    } else {
      _orders.add(OrderItem(
        id: Uuid().v1(),
        menuItem: menuItem,
        completed: false,
        quantity: 1,
        reservationId: reservationId,
      ));
    }

    _total += menuItem.price;

    notifyListeners();
  }

  void removeFromCart(MenuItem menuItem) {
    int index = _orders.indexWhere((order) => order.menuItem.id == menuItem.id);

    if (index >= 0) {
      if (_orders[index].quantity == 1) {
        _orders.removeAt(index);
      } else {
        _orders[index].quantity -= 1;
      }
      _total -= menuItem.price;
      notifyListeners();
    }
  }

  int getQuantity(String menuItemId) {
    return _orders
        .firstWhere(
          (order) => order.menuItem.id == menuItemId,
          orElse: () => OrderItem(quantity: 0),
        )
        .quantity;
  }
}
