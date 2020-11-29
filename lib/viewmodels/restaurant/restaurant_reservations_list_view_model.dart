import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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

  String getReservationStatus(String status, BuildContext context) {
    switch (status) {
      case ReservationStatus.CLOSED:
        return FlutterI18n.translate(
          context,
          'reservationStatus.${ReservationStatus.CLOSED}',
        );
      case ReservationStatus.ACTIVE:
        return FlutterI18n.translate(
          context,
          'reservationStatus.${ReservationStatus.ACTIVE}',
        );
      case ReservationStatus.ACTIVE_PAYING:
        return FlutterI18n.translate(
          context,
          'reservationStatus.${ReservationStatus.ACTIVE_PAYING}',
        );
      case ReservationStatus.CANCELLED:
        return FlutterI18n.translate(
          context,
          'reservationStatus.${ReservationStatus.CANCELLED}',
        );
      case ReservationStatus.SEEN_INACTIVE:
      case ReservationStatus.UNSEEN_INACTIVE:
        return FlutterI18n.translate(
          context,
          'reservationStatus.${ReservationStatus.SEEN_INACTIVE}',
        );
      default:
        return FlutterI18n.translate(
          context,
          'reservationStatus.unknown',
        );
    }
  }

  void updateStatusFilterOptions(String statusTitle) {
    int index = _statusFilterList.indexWhere(
      (option) => option.title == statusTitle,
    );
    _statusFilterList[index].isSelected = !_statusFilterList[index].isSelected;
    _statusFilterListValues.add(_statusFilterList[index].filterValue);
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
