import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authService.isUserLoggedIn();
    bool doesUserHaveRestaurant = await _firestoreService
        .doesUserHaveRestaurant(_authService.currentUser.id);

    if (hasLoggedInUser) {
      switch (_authService.currentUser.userRole) {
        case "CUSTOMER":
          _navigationService.navigateTo(MainViewRoute);
          break;
        case 'RESTAURANT':
          if (doesUserHaveRestaurant) {
            _navigationService.navigateTo(RestaurantMainViewRoute);
          } else {
            _navigationService.navigateTo(NewRestaurantStepperViewRoute);
          }
          break;
      }
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }
  }
}
