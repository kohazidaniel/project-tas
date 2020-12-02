import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/models/order_item.dart';
import 'package:tas/models/tas_notification.dart';
import 'package:tas/models/rating.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_restaurant.dart';
import 'package:tas/models/reservation_with_user.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/models/tas_user.dart';
import 'package:tas/services/push_notification_service.dart';

class FirestoreService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _restaurants =
      FirebaseFirestore.instance.collection('restaurants');
  final CollectionReference _menuItems =
      FirebaseFirestore.instance.collection('menuitems');
  final CollectionReference _reservations =
      FirebaseFirestore.instance.collection('reservations');
  final CollectionReference _notifications =
      FirebaseFirestore.instance.collection('notifications');

  final StreamController<List<MenuItem>> _menuItemsController =
      StreamController<List<MenuItem>>.broadcast();

  final StreamController<int> _unSeenReservationListLengthController =
      StreamController<int>.broadcast();

  final StreamController<bool> _userReservationInProgressController =
      StreamController<bool>.broadcast();

  final StreamController<ReservationWithRestaurant>
      _reservationWithRestaurantController =
      StreamController<ReservationWithRestaurant>.broadcast();

  final StreamController<ReservationWithUser> _reservationWithUserController =
      StreamController<ReservationWithUser>.broadcast();

  final StreamController<List<TasNotification>>
      _userNotificationListController =
      StreamController<List<TasNotification>>.broadcast();

  final StreamController<int> _userNotificationListLengthController =
      StreamController<int>.broadcast();

  final StreamController<List<OrderItem>> _orderItemsController =
      StreamController<List<OrderItem>>.broadcast();

  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

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

  Stream<List<MenuItem>> listenToMenuItems(String restaurantId) {
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

  Stream<ReservationWithUser> listenToReservationWithUser(
    String reservationId,
  ) {
    _reservations
        .doc(reservationId)
        .snapshots()
        .listen((reservationSnapshot) async {
      Reservation reservation = Reservation.fromData(
        reservationSnapshot.data(),
      );

      var userData = await _users.doc(reservation.userId).get();

      _reservationWithUserController.add(
        ReservationWithUser(
          reservation: reservation,
          user: TasUser.fromData(
            userData.data(),
          ),
        ),
      );
    });

    return _reservationWithUserController.stream;
  }

  Stream<ReservationWithRestaurant> listenToReservationWithRestaurant(
    String reservationId,
  ) {
    _reservations
        .doc(reservationId)
        .snapshots()
        .listen((reservationSnapshot) async {
      Reservation reservation = Reservation.fromData(
        reservationSnapshot.data(),
      );

      var restaurantData =
          await _restaurants.doc(reservation.restaurantId).get();

      _reservationWithRestaurantController.add(
        ReservationWithRestaurant(
          reservation: reservation,
          restaurant: Restaurant.fromData(
            restaurantData.data(),
          ),
        ),
      );
    });

    return _reservationWithRestaurantController.stream;
  }

  Future<void> startReservation(String reservationId, String userId) async {
    try {
      _users.doc(userId).update({'inProgressReservationId': reservationId});
      _reservations.doc(reservationId).update({
        'status': ReservationStatus.ACTIVE,
      });
    } catch (e) {
      return e;
    }
  }

  Future<void> setReservationStatusToPay(
    String reservationId,
    String userId,
  ) async {
    try {
      _users.doc(userId).update({'inProgressReservationId': ''});
      _reservations.doc(reservationId).update({
        'status': ReservationStatus.ACTIVE_PAYING,
      });
    } catch (e) {
      return e;
    }
  }

  Stream<int> listenToUnSeenReservationListLength(String userId) {
    _reservations.snapshots().listen((reservationSnapshot) {
      var menuItems = reservationSnapshot.docs
          .map((snapshot) => Reservation.fromData(snapshot.data()))
          .where(
            (mappedItem) =>
                mappedItem.userId == userId &&
                mappedItem.status == ReservationStatus.UNSEEN_INACTIVE,
          )
          .toList();
      _unSeenReservationListLengthController.add(menuItems.length);
    });

    return _unSeenReservationListLengthController.stream;
  }

  Future<void> setReservationSeen(String reservationId) async {
    try {
      _reservations.doc(reservationId).update({
        'status': ReservationStatus.SEEN_INACTIVE,
      });
    } catch (e) {
      return e;
    }
  }

  Future<void> deleteReservation(String reservationId) async {
    try {
      _reservations
          .doc(reservationId)
          .update({'status': ReservationStatus.CANCELLED});
    } catch (e) {
      return e;
    }
  }

  Future<void> closeReservation(String reservationId) async {
    try {
      _reservations
          .doc(reservationId)
          .update({'status': ReservationStatus.CLOSED});
    } catch (e) {
      return e;
    }
  }

  Future<void> orderMenuItems(
    List<OrderItem> orders,
    int total,
    String reservationId,
  ) async {
    try {
      var reservationSnap = await _reservations.doc(reservationId).get();

      Reservation reservation = Reservation.fromData(reservationSnap.data());

      _reservations.doc(reservationId).update({
        'orders': FieldValue.arrayUnion(orders.map((e) => e.toJson()).toList()),
        'total': total + reservation.total,
      });
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

  Future<void> rateRestaurant(
    Rating rating,
    String restaurantId,
    String reservationId,
  ) async {
    try {
      var restaurantSnap = await _restaurants.doc(restaurantId).get();

      Restaurant restaurant = Restaurant.fromData(restaurantSnap.data());

      _restaurants.doc(restaurantId).update({
        'ratings': [...restaurant.ratings, rating.rating],
      });

      _reservations.doc(reservationId).update({
        'rating': rating.toJson(),
      });
    } catch (e) {
      return e;
    }
  }

  Stream<List<ReservationWithUser>> listenToRestaurantReservations(
    String restaurantId,
  ) {
    return _reservations
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('reservationDate', descending: true)
        .snapshots()
        .asyncMap(
          (QuerySnapshot reservationSnap) => restaurantReservationToPairs(
            reservationSnap,
          ),
        );
  }

  Future<List<ReservationWithUser>> restaurantReservationToPairs(
    QuerySnapshot reservationSnap,
  ) {
    return Future.wait(
        reservationSnap.docs.map((DocumentSnapshot reservationDoc) async {
      return await restaurantReservationToPair(reservationDoc);
    }).toList());
  }

  Future<ReservationWithUser> restaurantReservationToPair(
    DocumentSnapshot reservationDoc,
  ) {
    Reservation reservation = Reservation.fromData(reservationDoc.data());

    return _users.doc(reservation.userId).get().then((userSnapshot) {
      TasUser user = TasUser.fromData(userSnapshot.data());
      return ReservationWithUser(
        reservation: reservation,
        user: user,
      );
    });
  }

  Stream<List<TasNotification>> listenNotificationList(String userId) {
    _notifications.snapshots().listen((notificationSnapshot) {
      var notifications = notificationSnapshot.docs
          .map((snapshot) => TasNotification.fromData(snapshot.data()))
          .where((mappedItem) => mappedItem.userId == userId)
          .toList();

      notifications.sort((a, b) => b.createDate.compareTo(a.createDate));

      _userNotificationListController.add(notifications);
    });

    return _userNotificationListController.stream;
  }

  Stream<int> listenToUnSeenNotificationListLength(String userId) {
    _notifications.snapshots().listen((notificationSnapshot) {
      var notifications = notificationSnapshot.docs
          .map((snapshot) => TasNotification.fromData(snapshot.data()))
          .where(
              (mappedItem) => mappedItem.userId == userId && !mappedItem.seen)
          .toList();

      _userNotificationListLengthController.add(notifications.length);
    });

    return _userNotificationListLengthController.stream;
  }

  Future sendNotification(TasNotification notification, String fcmToken) async {
    try {
      await _pushNotificationService.sendAndPushNotification(
        notification,
        fcmToken,
      );

      await _notifications.doc(notification.id).set(notification.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future setNofiticationSeen(String notificationId) async {
    try {
      await _notifications.doc(notificationId).update({'seen': true});
    } catch (e) {
      return e.message;
    }
  }

  Future completeOrder(String reservationId, String orderItemId) async {
    try {
      var reservationSnap = await _reservations.doc(reservationId).get();

      Reservation reservation = Reservation.fromData(reservationSnap.data());

      int index =
          reservation.orders.indexWhere((order) => order.id == orderItemId);

      if (index >= 0) {
        reservation.orders[index].completed = true;
      }

      await _reservations.doc(reservationId).update({
        'orders': reservation.orders.map((e) => e.toJson()).toList(),
      });
    } catch (e) {
      return e.message;
    }
  }

  Future updateFcmToken({
    String userId,
    String fcmToken,
    String restaurantId,
  }) async {
    try {
      await _users.doc(userId).update({'fcmToken': fcmToken});
      if (restaurantId.isNotEmpty) {
        await _restaurants.doc(restaurantId).update({'fcmToken': fcmToken});
      }
    } catch (e) {
      return e.message;
    }
  }

  Future deleteNotification(String notificationId) async {
    try {
      await _notifications.doc(notificationId).delete();
    } catch (e) {
      return e.message;
    }
  }

  Stream<List<OrderItem>> listenToOrders(String restaurantId) {
    _reservations.snapshots().listen((reservationsSnapshot) {
      var reservations = reservationsSnapshot.docs
          .map((snapshot) => Reservation.fromData(snapshot.data()))
          .where((mappedItem) => mappedItem.restaurantId == restaurantId)
          .toList();

      var orderItems = [];

      reservations.forEach((reservation) {
        reservation.orders.forEach((order) {
          orderItems.add(order);
        });
      });

      _orderItemsController.add(orderItems);
    });

    return _orderItemsController.stream;
  }
}
