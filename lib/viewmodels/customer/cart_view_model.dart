import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_restaurant.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
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

  String getFormattedDate(DateTime dateTime) {
    DateFormat formatter = new DateFormat.yMMMMd('hu');

    return formatter.format(dateTime) +
        ' ${dateTime.hour}:' +
        '${dateTime.minute.toString().length == 1 ? '0' : ''}' +
        '${dateTime.minute}';
  }

  void navToReservationDetails(String reservationId) {
    _navigationService.navigateTo(
      ReservationViewRoute,
      arguments: reservationId,
    );
  }
}
