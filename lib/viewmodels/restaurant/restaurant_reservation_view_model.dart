import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_user_and_menuitems.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/ui/widgets/blinking_point.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:intl/intl.dart';
import 'package:tas/viewmodels/customer/active_reservation_model.dart';

class RestaurantReservationViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final String reservationId;
  RestaurantReservationViewModel({this.reservationId});

  Stream<ReservationWithUserAndMenuItems>
      listenToReservationWithUserAndMenuItems() {
    return _firestoreService.listenToReservationWithUserAndMenuItems(
      reservationId,
    );
  }

  void closeReservation(String reservationId) async {
    await _firestoreService.closeReservation(reservationId);
  }

  String getFormattedDate(DateTime dateTime) {
    DateFormat formatter = new DateFormat.yMMMMd('hu');

    return formatter.format(dateTime) +
        ' ${dateTime.hour}:' +
        '${dateTime.minute.toString().length == 1 ? '0' : ''}' +
        '${dateTime.minute}';
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

  List<MenuItemWithQuantity> groupMenuItems(List<MenuItem> menuItems) {
    List<MenuItemWithQuantity> groupedMenuItems = [];

    menuItems.forEach((MenuItem menuItem) {
      bool inList = groupedMenuItems
              .where(
                (groupedMenuItem) => groupedMenuItem.menuItem.id == menuItem.id,
              )
              .length >
          0;

      if (inList) {
        int idx = groupedMenuItems.indexWhere(
          (groupedMenuItem) => groupedMenuItem.menuItem.id == menuItem.id,
        );
        groupedMenuItems[idx].quantity += 1;
      } else {
        groupedMenuItems.add(
          MenuItemWithQuantity(
            menuItem: menuItem,
            quantity: 1,
          ),
        );
      }
    });

    return groupedMenuItems;
  }
}
