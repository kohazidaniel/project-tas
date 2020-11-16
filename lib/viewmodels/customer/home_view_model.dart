import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class HomeViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

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

  List getRestaurantTypes() {
    List categories = [];
    Map<String, int> groupCategories = {};

    _restaurants.forEach((restaurant) {
      restaurant.restaurantTypes.forEach((restaurantType) {
        if (groupCategories.containsKey(restaurantType)) {
          groupCategories[restaurantType] += 1;
        } else {
          groupCategories[restaurantType] = 1;
        }
      });
    });

    groupCategories.forEach((key, value) {
      categories.add({'name': key, 'icon': getIcon(key), 'items': value});
    });

    return categories;
  }

  IconData getIcon(String restaurantType) {
    switch (restaurantType) {
      case 'BEER':
        return FontAwesomeIcons.beer;
      case 'CAFE':
        return FontAwesomeIcons.coffee;
      case 'BISTRO':
        return FontAwesomeIcons.utensils;
      case 'WINE':
        return FontAwesomeIcons.wineGlass;
      default:
        return FontAwesomeIcons.glassWhiskey;
    }
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

  void navToListByCategoriesView(String restaurantType) {
    _navigationService.navigateTo(
      ListByCategoriesViewRoute,
      arguments: restaurantType,
    );
  }
}
