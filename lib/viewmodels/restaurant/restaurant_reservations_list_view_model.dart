import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_user.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/models/restaurant_reservations_list_filter_options.dart';
import 'package:intl/intl.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantReservationsListViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  DateTime _filterStartDate;
  DateTime get filterStartDate => _filterStartDate;
  DateTime _filterEndDate;
  DateTime get filterEndDate => _filterEndDate;

  Stream<List<ReservationWithUser>> listenToRestaurantReservations() {
    Stream<List<ReservationWithUser>> stream =
        _firestoreService.listenToRestaurantReservations(
      _authenticationService.userRestaurant.id,
    );

    return stream;
  }

  List<String> _statusFilterListValues = [];

  void navToReservation(String reservationId) {
    _navigationService.navigateTo(
      RestaurantReservationViewRoute,
      arguments: reservationId,
    );
  }

  bool filterReservation(ReservationWithUser reservationWithUser) {
    bool statusCondition = true;
    bool startDateCondtiion = true;
    bool endDateCondition = true;

    if (_statusFilterListValues.isNotEmpty) {
      statusCondition = _statusFilterListValues.contains(
        reservationWithUser.reservation.status,
      );
    }

    if (_filterStartDate != null) {
      startDateCondtiion = reservationWithUser.reservation.reservationDate
          .toDate()
          .isAfter(_filterStartDate);
    }

    if (_filterEndDate != null) {
      endDateCondition = reservationWithUser.reservation.reservationDate
          .toDate()
          .isBefore(_filterEndDate.add(Duration(days: 1)));
    }

    return statusCondition && startDateCondtiion && endDateCondition;
  }

  void updateStatusFilterOptions(String statusTitle) {
    int index = _statusFilterList.indexWhere(
      (option) => option.title == statusTitle,
    );
    _statusFilterList[index].isSelected = !_statusFilterList[index].isSelected;

    if (_statusFilterListValues.contains(
      _statusFilterList[index].filterValue,
    )) {
      _statusFilterListValues.remove(_statusFilterList[index].filterValue);
    } else {
      _statusFilterListValues.add(_statusFilterList[index].filterValue);
    }

    notifyListeners();
  }

  Future<void> selectDate(BuildContext context, bool isEndDate) async {
    DateTime initialDate = isEndDate
        ? _filterEndDate ?? DateTime.now()
        : _filterStartDate ?? DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      locale: Locale('hu'),
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(
        Duration(days: 30),
      ),
      lastDate: DateTime.now().add(
        Duration(days: 30),
      ),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      if (isEndDate) {
        _filterEndDate = picked;
      } else {
        _filterStartDate = picked;
      }
    }
    notifyListeners();
  }

  void clearDateFilter() {
    _filterEndDate = null;
    _filterStartDate = null;
    notifyListeners();
  }

  List<RestaurantReservationsListFilterOptions> get statusFilterList =>
      _statusFilterList;

  List<RestaurantReservationsListFilterOptions> _statusFilterList = [
    RestaurantReservationsListFilterOptions(
      title: 'Folyamatban',
      filterValue: ReservationStatus.ACTIVE,
      isSelected: false,
    ),
    RestaurantReservationsListFilterOptions(
      title: 'Fizetésre vár',
      filterValue: ReservationStatus.ACTIVE_PAYING,
      isSelected: false,
    ),
    RestaurantReservationsListFilterOptions(
      title: 'Törölve',
      filterValue: ReservationStatus.CANCELLED,
      isSelected: false,
    ),
    RestaurantReservationsListFilterOptions(
      title: 'Kifizetve',
      filterValue: ReservationStatus.CLOSED,
      isSelected: false,
    ),
    RestaurantReservationsListFilterOptions(
      title: 'Lefoglalva',
      filterValue: ReservationStatus.SEEN_INACTIVE,
      isSelected: false,
    ),
  ];
}
