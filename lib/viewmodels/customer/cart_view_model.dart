import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_restaurant.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/ui/widgets/blinking_point.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:intl/intl.dart';

class CartViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<Reservation>> getUserReservations() {
    return _firestoreService
        .getUserReservations(_authenticationService.currentUser.id);
  }

  Stream<List<ReservationWithRestaurant>> listenToUserReservations() {
    return _firestoreService
        .listenToUserReservations(_authenticationService.currentUser.id);
  }

  Future<Restaurant> getReservationRestaurant(String restaurantId) {
    return _firestoreService.getRestaurantById(restaurantId);
  }

  void navToReservation(Reservation reservation) {
    if (reservation.status == ReservationStatus.ACTIVE) {
      _navigationService.navigateTo(
        ActiveReservationViewRoute,
        arguments: reservation.id,
      );
    } else {
      _navigationService.navigateTo(
        ReservationViewRoute,
        arguments: reservation.id,
      );
    }
  }

  Widget getTrailing(String reservationStatus) {
    switch (reservationStatus) {
      case ReservationStatus.ACTIVE:
        return BlinkingPoint(
          xCoor: -10.0,
          yCoor: 0.0,
          pointColor: Colors.red,
          pointSize: 10.0,
        );
      case ReservationStatus.UNSEEN_INACTIVE:
        return Container(
          padding: EdgeInsets.all(1),
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          constraints: BoxConstraints(
            maxWidth: 10,
            maxHeight: 10,
          ),
        );
      case ReservationStatus.ACTIVE_PAYING:
        return Icon(
          FontAwesomeIcons.handHoldingUsd,
          size: 18.0,
        );
      case ReservationStatus.CLOSED:
        return Icon(
          FontAwesomeIcons.solidCheckCircle,
          size: 18.0,
        );
      case ReservationStatus.CANCELLED:
        return Icon(
          FontAwesomeIcons.solidTimesCircle,
          size: 18.0,
        );
      default:
        return SizedBox.shrink();
    }
  }
}
