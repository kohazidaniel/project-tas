import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/models/tas_user.dart';

class FirestoreService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _restaurants =
      FirebaseFirestore.instance.collection('restaurants');
  final CollectionReference _menuItems =
      FirebaseFirestore.instance.collection('menuitems');

  final StreamController<List<MenuItem>> _menuItemsController =
      StreamController<List<MenuItem>>.broadcast();

  Future createUser(TasUser user) async {
    try {
      await _users.doc(user.id).set(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _users.doc(uid).get();
      return TasUser.fromData(userData.data());
    } catch (e) {
      return null;
    }
  }

  Future createRestaurant(Restaurant restaurant) async {
    try {
      await _restaurants.doc(restaurant.id).set(restaurant.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future createMenuItem(MenuItem menuItem) async {
    try {
      await _menuItems.doc(menuItem.id).set(menuItem.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future updateMenuItem(MenuItem menuItem) async {
    try {
      await _menuItems.doc(menuItem.id).update(menuItem.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future deleteMenuItem(String menuItemId) async {
    await _menuItems.doc(menuItemId).delete();
  }

  Stream<List<MenuItem>> listenToMenuItemsRealTime(String restaurantId) {
    _menuItems
        .orderBy('menuItemType', descending: true)
        .snapshots()
        .listen((menuItemsSnapshot) {
      var menuItems = menuItemsSnapshot.docs
          .map((snapshot) => MenuItem.fromData(snapshot.data()))
          .where((mappedItem) => mappedItem.restaurantId == restaurantId)
          .toList();
      _menuItemsController.add(menuItems);
    });

    return _menuItemsController.stream;
  }

  Future doesUserHaveRestaurant(String userId) async {
    if (userId == null) return false;
    try {
      var restaurantData = await _restaurants
          .where(
            'ownerId',
            isEqualTo: userId,
          )
          .get();

      return restaurantData.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Restaurant> getUserRestaurant(String userId) async {
    try {
      var restaurantData =
          await _restaurants.where('ownerId', isEqualTo: userId).get();

      return Restaurant.fromData(restaurantData.docs.first.data());
    } catch (e) {
      return null;
    }
  }

  Future<List<Restaurant>> getRestaurants() async {
    try {
      var restaurantsSnapshot = await _restaurants.get();

      return restaurantsSnapshot.docs
          .map((restaurant) => Restaurant.fromData(restaurant.data()))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>> getUserFavouriteRestaurants(String uid) async {
    try {
      var userData = await _users.doc(uid).get();
      return (userData.data()['favouriteRestaurants'] as List<dynamic>)
          .cast<String>();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future addRestaurantToUserFavourites(
      List<String> favouriteRestaurants, String userId) async {
    try {
      _users.doc(userId).update({'favouriteRestaurants': favouriteRestaurants});
    } catch (e) {
      return e;
    }
  }
}
