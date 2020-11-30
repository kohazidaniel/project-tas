import 'dart:async';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_user.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/models/restaurant_reservations_list_filter_options.dart';
import 'package:intl/intl.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantReservationsListViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Stream<List<ReservationWithUser>> listenToRestaurantReservations() {
    Stream<List<ReservationWithUser>> stream =
        _firestoreService.listenToRestaurantReservations(
      _authenticationService.userRestaurant.id,
    );

    return stream;
  }

  List<String> _statusFilterListValues = [];

  String getFormattedDate(DateTime dateTime) {
    DateFormat formatter = new DateFormat.yMMMMd('hu');

    return formatter.format(dateTime) +
        ' ${dateTime.hour}:' +
        '${dateTime.minute.toString().length == 1 ? '0' : ''}' +
        '${dateTime.minute}';
  }

  void navToReservation(String reservationId) {
    _navigationService.navigateTo(
      RestaurantReservationViewRoute,
      arguments: reservationId,
    );
  }

  bool filterReservation(ReservationWithUser reservationWithUser) {
    if (_statusFilterListValues.isNotEmpty) {
      return _statusFilterListValues.contains(
        reservationWithUser.reservation.status,
      );
    }

    return true;
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
