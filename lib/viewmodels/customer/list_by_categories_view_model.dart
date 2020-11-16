import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class ListByCategoriesViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<List<Restaurant>> getRestaurantsByType(String restaurantType) {
    return _firestoreService.getRestaurantsByType(restaurantType);
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

  void navToRestaurantDetailsView(String restaurantId) {
    _navigationService.navigateTo(
      PlaceDetailsViewRoute,
      arguments: restaurantId,
    );
  }

  void navToBack() {
    _navigationService.pop();
  }
}
