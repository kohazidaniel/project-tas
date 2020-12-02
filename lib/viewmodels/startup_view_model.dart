import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/services/push_notification_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authService.isUserLoggedIn();
    await _pushNotificationService.initialise();

    if (hasLoggedInUser) {
      bool doesUserHaveRestaurant = await _firestoreService
          .doesUserHaveRestaurant(_authService.currentUser.id);

      String fcmToken = await _pushNotificationService.getFcmToken();

      if (fcmToken != _authService.currentUser.fcmToken) {
        await _firestoreService.updateFcmToken(
          userId: _authService.currentUser.id,
          fcmToken: fcmToken,
          restaurantId: _authService.userRestaurant != null
              ? _authService.userRestaurant.id
              : "",
        );
        await _authService.refreshUser();
      }

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
        default:
          _navigationService.navigateTo(LoginViewRoute);
          break;
      }
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }
  }
}
