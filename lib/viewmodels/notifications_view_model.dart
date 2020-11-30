import 'package:tas/locator.dart';
import 'package:tas/models/tas_notification.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class NotificationViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authenticationService = locator<AuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Stream<List<TasNotification>> listenNotificationList() {
    return _firestoreService.listenNotificationList(
      _authenticationService.currentUser.id,
    );
  }
}
