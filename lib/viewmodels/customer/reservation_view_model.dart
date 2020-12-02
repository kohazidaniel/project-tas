import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/models/tas_notification.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/dialog_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ReservationViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();

  String _reservationId;
  ReservationViewModel(String reservationId) {
    _reservationId = reservationId;
  }

  Reservation _reservation;
  Reservation get reservation => _reservation;

  Restaurant _restaurant;
  Restaurant get restaurant => _restaurant;

  void getReservation() async {
    _reservation = await _firestoreService.getReservationById(_reservationId);
    _restaurant =
        await _firestoreService.getRestaurantById(_reservation.restaurantId);
    notifyListeners();

    if (_reservation.status == ReservationStatus.UNSEEN_INACTIVE) {
      await _firestoreService.setReservationSeen(_reservationId);
    }
  }

  void navToPlaceDetailsView(String restaurantId) {
    _navigationService.navigateTo(
      PlaceDetailsViewRoute,
      arguments: restaurantId,
    );
  }

  void navToBack() {
    _navigationService.pop();
  }

  Future<void> startReservation() async {
    setBusy(true);

    await _firestoreService.sendNotification(
      TasNotification(
        id: Uuid().v1(),
        content: '${_authService.currentUser.fullName} foglalást indított el',
        createDate: Timestamp.now(),
        navigationId: reservation.id,
        navigationRoute: RestaurantReservationViewRoute,
        seen: false,
        userId: restaurant.id,
      ),
      restaurant.fcmToken,
    );

    await _firestoreService.startReservation(
      reservation.id,
      _authService.currentUser.id,
    );

    _authService.refreshUser();

    setBusy(false);

    _navigationService.pop();
    _navigationService.navigateTo(
      ActiveReservationViewRoute,
      arguments: _reservation.id,
    );
  }

  Future<void> deleteReservation() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Asztalfoglalás',
      content: Text('Biztos törölni szeretnéd a foglalást?'),
      confirmationTitle: 'Igen',
      cancelTitle: 'Nem',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      await _firestoreService.deleteReservation(reservation.id);
      setBusy(false);
      _navigationService.pop();
    }
  }

  bool canStartReservation() {
    return (_reservation.status == ReservationStatus.UNSEEN_INACTIVE ||
            _reservation.status == ReservationStatus.SEEN_INACTIVE) &&
        _authService.currentUser.inProgressReservationId.isEmpty &&
        _reservation.reservationDate
            .toDate()
            .subtract(Duration(minutes: 15))
            .isBefore(
              DateTime.now(),
            );
  }

  bool canDeleteReservation() {
    return (_reservation.status == ReservationStatus.UNSEEN_INACTIVE ||
            _reservation.status == ReservationStatus.SEEN_INACTIVE) &&
        _reservation.reservationDate
            .toDate()
            .subtract(
              Duration(hours: 2),
            )
            .isAfter(
              DateTime.now(),
            );
  }
}
