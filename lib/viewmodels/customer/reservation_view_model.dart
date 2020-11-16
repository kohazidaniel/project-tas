import 'package:tas/locator.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class ReservationViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService navigationService = locator<NavigationService>();

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

    if (!_reservation.seen) {
      await _firestoreService.setReservationSeen(_reservationId);
    }
  }
}
