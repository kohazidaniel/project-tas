import 'package:flutter/cupertino.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantMenuViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  ScrollController scrollController = new ScrollController();

  List<MenuItem> _menuItems;
  List<MenuItem> get menuItems => _menuItems;

  List<String> _menuItemTypes = ['Sör', 'Bor'];
  List<String> get menuItemTypes => _menuItemTypes;

  String _selectedMenuItemType = 'Sör';
  String get selectedMenuItemType => _selectedMenuItemType;

  Stream<List<MenuItem>> listenToPosts() {
    Stream<List<MenuItem>> stream = _firestoreService.listenToPostsRealTime(
      _authenticationService.userRestaurant.id,
    );

    return stream;
  }

  void setMenuItemType(String menuItemType) {
    _selectedMenuItemType = menuItemType;

    scrollController.animateTo(
      350,
      curve: Curves.ease,
      duration: Duration(milliseconds: 300),
    );

    notifyListeners();
  }
}
