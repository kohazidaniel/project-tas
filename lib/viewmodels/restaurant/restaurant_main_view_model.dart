import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_user.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/indicator.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantMainViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  int _page = 0;
  int get page => _page;

  Restaurant _userRestaurant;
  Restaurant get userRestaurant => _userRestaurant;

  void getUserRestaurant() async {
    _userRestaurant = await _firestoreService
        .getUserRestaurant(_authenticationService.currentUser.id);
    notifyListeners();
  }

  Stream<int> listenToUnSeenNotificationListLength() {
    return _firestoreService.listenToUnSeenNotificationListLength(
      _authenticationService.userRestaurant.id,
    );
  }

  Stream<List<ReservationWithUser>> listenToRestaurantReservations() {
    return _firestoreService.listenToRestaurantReservations(
      _authenticationService.userRestaurant.id,
    );
  }

  Stream<List<Reservation>> listenToTodaysReservations() {
    return _firestoreService.listenToTodaysReservations(
      _authenticationService.userRestaurant.id,
    );
  }

  Stream<List<Reservation>> listenToWeeklyReservations() {
    return _firestoreService.listenToWeeklyReservations(
      _authenticationService.userRestaurant.id,
    );
  }

  void navToReservation(String reservationId) {
    _navigationService.navigateTo(
      RestaurantReservationViewRoute,
      arguments: reservationId,
    );
  }

  List<Indicator> getIndicators(
    List<Reservation> reservations,
    BuildContext context,
  ) {
    List<String> statusList = [];

    reservations.forEach((reservation) {
      if (!statusList.contains(reservation.status)) {
        statusList.add(reservation.status);
      }
    });

    return statusList
        .map(
          (status) => Indicator(
            color: getStatusColor(status),
            text: FlutterI18n.translate(context, 'reservationStatus.$status'),
            isSquare: true,
          ),
        )
        .toList();
  }

  List<ChartColorAndValue> getChartColorsAndValues(
    List<Reservation> reservations,
  ) {
    List<ChartColorAndValue> chartColorsAndValues = [];

    reservations.forEach((reservation) {
      int index = chartColorsAndValues.indexWhere(
        (e) => e.key == reservation.status,
      );

      if (index >= 0) {
        chartColorsAndValues[index].value += 1;
      } else {
        chartColorsAndValues.add(
          ChartColorAndValue(
            key: reservation.status,
            color: getStatusColor(reservation.status),
            value: 1,
          ),
        );
      }
    });

    return chartColorsAndValues;
  }

  List<WeekDayWithValue> getWeekDayValuesList(
    List<Reservation> reservations,
  ) {
    List<WeekDayWithValue> weekDayValues = [
      WeekDayWithValue(weekDayKey: 'monday', value: 0),
      WeekDayWithValue(weekDayKey: 'tuesday', value: 0),
      WeekDayWithValue(weekDayKey: 'wednesday', value: 0),
      WeekDayWithValue(weekDayKey: 'thursday', value: 0),
      WeekDayWithValue(weekDayKey: 'friday', value: 0),
      WeekDayWithValue(weekDayKey: 'saturday', value: 0),
      WeekDayWithValue(weekDayKey: 'sunday', value: 0),
    ];

    reservations.forEach((reservation) {
      int dayIndex = reservation.reservationDate.toDate().weekday;

      weekDayValues[dayIndex - 1].value += 1;
    });

    return weekDayValues;
  }

  Color getStatusColor(String reservationStatus) {
    switch (reservationStatus) {
      case ReservationStatus.ACTIVE:
        return Colors.green;
      case ReservationStatus.ACTIVE_PAYING:
        return Colors.purple;
      case ReservationStatus.CANCELLED:
        return Colors.red;
      case ReservationStatus.CLOSED:
        return Colors.blue;
      case ReservationStatus.SEEN_INACTIVE:
      case ReservationStatus.UNSEEN_INACTIVE:
        return Colors.yellow;
      default:
        return Colors.black;
    }
  }
}

class ChartColorAndValue {
  final String key;
  final Color color;
  double value;

  ChartColorAndValue({this.key, this.color, this.value});
}

class WeekDayWithValue {
  final String weekDayKey;
  double value;

  WeekDayWithValue({this.weekDayKey, this.value});
}
