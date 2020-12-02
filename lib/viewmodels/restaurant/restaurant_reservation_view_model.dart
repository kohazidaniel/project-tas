import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/order_item.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_user.dart';
import 'package:tas/models/tas_notification.dart';
import 'package:tas/models/tas_user.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/ui/widgets/blinking_point.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class RestaurantReservationViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final String reservationId;
  RestaurantReservationViewModel({this.reservationId});

  Stream<ReservationWithUser> listenToReservationWithUser() {
    return _firestoreService.listenToReservationWithUser(
      reservationId,
    );
  }

  void closeReservation(String reservationId, TasUser user) async {
    await _firestoreService.sendNotification(
      TasNotification(
        id: Uuid().v1(),
        content: 'Sikeres fizetés, reméljük jól éreztétek magatokat',
        navigationId: reservationId,
        navigationRoute: ReservationViewRoute,
        seen: false,
        userId: user.id,
        createDate: Timestamp.now(),
      ),
      user.fcmToken,
    );

    await _firestoreService.closeReservation(reservationId);
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

  Future completeOrder(String reservationId, String orderItemId) async {
    await _firestoreService.completeOrder(reservationId, orderItemId);
  }

  List<OrderItem> groupOrdersById(List<OrderItem> completedOrders) {
    List<OrderItem> groupedOrders = [];

    completedOrders.forEach((OrderItem order) {
      int index = groupedOrders.indexWhere(
        (completedOrder) => completedOrder.menuItem.id == order.menuItem.id,
      );

      if (index >= 0) {
        groupedOrders[index].quantity += order.quantity;
      } else {
        groupedOrders.add(order);
      }
    });

    return groupedOrders;
  }
}
