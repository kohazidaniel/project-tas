import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantMainViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  final PageController _pageController = PageController();
  final ContainerTransitionType _transitionType =
      ContainerTransitionType.fadeThrough;

  ContainerTransitionType get transitionType => _transitionType;
  NavigationService get navigationService => _navigationService;
  PageController get pageController => _pageController;

  int _page = 0;
  int get page => _page;

  Restaurant _userRestaurant;
  Restaurant get userRestaurant => _userRestaurant;

  void getUserRestaurant() async {
    _userRestaurant = await _firestoreService
        .getUserRestaurant(_authenticationService.currentUser.id);
    notifyListeners();
  }

  void onPageChanged(int page) {
    this._page = page;
    notifyListeners();
  }
}
