import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class PlaceDetailsViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  final String restaurantId;
  PlaceDetailsViewModel({this.restaurantId});

  Restaurant _restaurant;
  Restaurant get restaurant => _restaurant;

  List<String> _favouriteRestaurants;
  List<String> get favouriteRestaurants => _favouriteRestaurants;

  void getViewData() async {
    _favouriteRestaurants = await _firestoreService
        .getUserFavouriteRestaurants(_authenticationService.currentUser.id);
    _restaurant = await _firestoreService.getRestaurantById(restaurantId);

    notifyListeners();
  }

  void addToFavourites(String restaurantId) {
    if (_favouriteRestaurants.contains(restaurantId)) {
      _favouriteRestaurants.remove(restaurantId);
    } else {
      _favouriteRestaurants.add(restaurantId);
    }
    _firestoreService.addRestaurantToUserFavourites(
      _favouriteRestaurants,
      _authenticationService.currentUser.id,
    );
    notifyListeners();
  }
}
