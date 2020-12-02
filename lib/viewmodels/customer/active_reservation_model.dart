import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/models/order_item.dart';
import 'package:tas/models/rating.dart';
import 'package:tas/models/reservation_with_restaurant.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/models/tas_notification.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/rating_dialog.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/dialog_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:uuid/uuid.dart';

class ActiveReservationViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final String reservationId;
  ActiveReservationViewModel({this.reservationId});

  Stream<ReservationWithRestaurant> listenToReservationWithRestaurant() {
    return _firestoreService.listenToReservationWithRestaurant(
      reservationId,
    );
  }

  void setReservationStatusToPay(
    int total,
    BuildContext context,
    Restaurant restaurant,
  ) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Fizetés',
      content: Text(
          'A foglalás le fog zárulni, ezután már több rendelést nem tudtok leadni.\n\n' +
              'Biztos ezt szeretnétek?\n\n' +
              'Végösszeg: $total forint'),
      confirmationTitle: 'Fizetés',
      cancelTitle: 'Mégse',
    );

    if (dialogResponse.confirmed) {
      await _firestoreService.sendNotification(
        TasNotification(
          id: Uuid().v1(),
          content: '${_authService.currentUser.fullName} lezárta a foglalást',
          navigationId: reservationId,
          navigationRoute: RestaurantReservationViewRoute,
          seen: false,
          userId: restaurant.id,
          createDate: Timestamp.now(),
        ),
        restaurant.fcmToken,
      );

      await _firestoreService.setReservationStatusToPay(
        reservationId,
        _authService.currentUser.id,
      );

      await _authService.refreshUser();

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return RatingDialog(
            title: "${restaurant.name}",
            description: "Hogyan éreztétek magatokat?",
            submitButton: "ÉRTÉKELÉS",
            alternativeButton: "Kihagyás",
            accentColor: primaryColor,
            starColor: Colors.yellow,
            onSubmitPressed: (int rating, String comment) async {
              await _firestoreService.rateRestaurant(
                Rating(
                  userName: _authService.currentUser.fullName,
                  comment: comment,
                  rating: rating,
                ),
                restaurant.id,
                reservationId,
              );
            },
            onAlternativePressed: () {
              Navigator.pop(context);
            },
          );
        },
      );

      _navigationService.pop();
    }
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
