import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_restaurant.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/models/tas_user.dart';

class FirestoreService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _restaurants =
      FirebaseFirestore.instance.collection('restaurants');
  final CollectionReference _menuItems =
      FirebaseFirestore.instance.collection('menuitems');
  final CollectionReference _reservations =
      FirebaseFirestore.instance.collection('reservations');

  final StreamController<List<MenuItem>> _menuItemsController =
      StreamController<List<MenuItem>>.broadcast();

  final StreamController<int> _unSeenReservationListLengthController =
      StreamController<int>.broadcast();

  final StreamController<bool> _userReservationInProgressController =
      StreamController<bool>.broadcast();

  // User  actions

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
    List<String> favouriteRestaurants,
    String userId,
  ) async {
    try {
      _users.doc(userId).update({'favouriteRestaurants': favouriteRestaurants});
    } catch (e) {
      return e;
    }
  }

  Stream<bool> listenToUserReservationInProgress(String userId) {
    _users.doc(userId).snapshots().listen((userSnapshot) {
      TasUser user = TasUser.fromData(userSnapshot.data());
      _userReservationInProgressController.add(
        user.inProgressReservationId.isNotEmpty,
      );
    });

    return _userReservationInProgressController.stream;
  }

  // Restaurant actions

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

  Future<Restaurant> getRestaurantById(String restaurantId) async {
    try {
      var restaurantSnapshot = await _restaurants.doc(restaurantId).get();

      return Restaurant.fromData(restaurantSnapshot.data());
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

  Future<List<Restaurant>> getRestaurantsByType(String restaurantType) async {
    try {
      var restaurantsSnapshot = await _restaurants
          .where('restaurantTypes', arrayContains: restaurantType)
          .orderBy('name', descending: true)
          .get();

      return restaurantsSnapshot.docs
          .map((restaurant) => Restaurant.fromData(restaurant.data()))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future updateOpeningHours(
    String openingHour,
    String restaurantId,
    bool isClosingTime,
  ) async {
    try {
      _restaurants
          .doc(restaurantId)
          .update({isClosingTime ? 'closingTime' : 'openingTime': openingHour});
    } catch (e) {
      return e;
    }
  }

  // User reservation actions

  Future createReservation(Reservation reservation) async {
    try {
      await _reservations.doc(reservation.id).set(reservation.toJson());
    } catch (e) {
      return e;
    }
  }

  Future<List<Reservation>> getUserReservations(String userId) async {
    try {
      var userReservationsSnapshot =
          await _reservations.where('userId', isEqualTo: userId).get();

      return userReservationsSnapshot.docs
          .map((reservation) => Reservation.fromData(reservation.data()))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<Reservation> getReservationById(String reservationId) async {
    try {
      var reservationSnapshot = await _reservations.doc(reservationId).get();

      return Reservation.fromData(reservationSnapshot.data());
    } catch (e) {
      return null;
    }
  }

  Future<ReservationWithRestaurant> getReservationWithRestaurantById(
      String reservationId) async {
    try {
      var reservationSnapshot = await _reservations.doc(reservationId).get();
      Reservation reservation = Reservation.fromData(
        reservationSnapshot.data(),
      );

      var restaurantSnapshot =
          await _restaurants.doc(reservation.restaurantId).get();

      return ReservationWithRestaurant(
        reservation: reservation,
        restaurant: Restaurant.fromData(restaurantSnapshot.data()),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> startReservation(String reservationId, String userId) async {
    try {
      _users.doc(userId).update({'inProgressReservationId': reservationId});
      _reservations.doc(reservationId).update({'active': true});
    } catch (e) {
      return e;
    }
  }

  Stream<int> listenToUnSeenReservationListLength(String userId) {
    _reservations.snapshots().listen((reservationSnapshot) {
      var menuItems = reservationSnapshot.docs
          .map((snapshot) => Reservation.fromData(snapshot.data()))
          .where(
              (mappedItem) => mappedItem.userId == userId && !mappedItem.seen)
          .toList();
      _unSeenReservationListLengthController.add(menuItems.length);
    });

    return _unSeenReservationListLengthController.stream;
  }

  Future<void> setReservationSeen(String reservationId) async {
    try {
      _reservations.doc(reservationId).update({'seen': true});
    } catch (e) {
      return e;
    }
  }

  Future<void> deleteReservation(String reservationId) async {
    try {
      _reservations.doc(reservationId).delete();
    } catch (e) {
      return e;
    }
  }

  Stream<List<ReservationWithRestaurant>> listenToUserReservations(
    String userId,
  ) {
    return _reservations
        .where('userId', isEqualTo: userId)
        .orderBy('reservationDate', descending: true)
        .snapshots()
        .asyncMap(
          (QuerySnapshot reservationSnap) => reservationToPairs(
            reservationSnap,
          ),
        );
  }

  Future<List<ReservationWithRestaurant>> reservationToPairs(
    QuerySnapshot reservationSnap,
  ) {
    return Future.wait(
        reservationSnap.docs.map((DocumentSnapshot reservationDoc) async {
      return await reservationToPair(reservationDoc);
    }).toList());
  }

  Future<ReservationWithRestaurant> reservationToPair(
    DocumentSnapshot reservationDoc,
  ) {
    Reservation reservation = Reservation.fromData(reservationDoc.data());

    return _restaurants
        .doc(reservation.restaurantId)
        .get()
        .then((restaurantSnapshot) {
      Restaurant restaurant = Restaurant.fromData(restaurantSnapshot.data());
      return ReservationWithRestaurant(
        reservation: reservation,
        restaurant: restaurant,
      );
    });
  }
}
