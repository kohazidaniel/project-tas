import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class HomeViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  List<Restaurant> _restaurants;
  List<Restaurant> get restaurants => _restaurants;

  Position _currentPosition;
  Position get currentPosition => _currentPosition;

  List<String> _favouriteRestaurants;
  List<String> get favouriteRestaurants => _favouriteRestaurants;

  void getViewData() async {
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _restaurants = await _firestoreService.getRestaurants();
    _favouriteRestaurants = await _firestoreService
        .getUserFavouriteRestaurants(_authenticationService.currentUser.id);
    notifyListeners();
  }

  List<Restaurant> getNearbyRestaurants() {
    return _restaurants
        .where(
          (restaurant) => isNearby(
            Position(
              latitude: restaurant.latitude,
              longitude: restaurant.longitude,
            ),
          ),
        )
        .toList();
  }

  bool isNearby(Position restaurantPosition) {
    return Geolocator.distanceBetween(
          restaurantPosition.latitude,
          restaurantPosition.longitude,
          _currentPosition.latitude,
          _currentPosition.longitude,
        ) <
        3000;
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
