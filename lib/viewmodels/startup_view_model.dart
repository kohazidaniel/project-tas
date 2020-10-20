import 'dart:developer';

import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authService.isUserLoggedIn();

    if (hasLoggedInUser) {
      switch (_authService.currentUser.userRole) {
        case "CUSTOMER":
          _navigationService.navigateTo(MainViewRoute);
          break;
        case 'RESTAURANT':
          _navigationService.navigateTo(NewRestaurantStepperViewRoute);
          break;
      }
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }
  }
}
