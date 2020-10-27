import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantMainViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  int _page = 0;
  int get page => _page;

  Restaurant _userRestaurant;
  Restaurant get userRestaurant => _userRestaurant;

  void getUserRestaurant() async {
    _userRestaurant = await _firestoreService
        .getUserRestaurant(_authenticationService.currentUser.id);
    notifyListeners();
  }
}
