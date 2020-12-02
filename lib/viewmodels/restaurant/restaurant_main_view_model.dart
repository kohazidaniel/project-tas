import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/reservation_with_user.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
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

  void navToReservation(String reservationId) {
    _navigationService.navigateTo(
      RestaurantReservationViewRoute,
      arguments: reservationId,
    );
  }
}
