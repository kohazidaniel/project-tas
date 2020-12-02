import 'package:flutter/cupertino.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/tas_notification.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/dialog_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class NotificationViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authenticationService = locator<AuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  Stream<List<TasNotification>> listenNotificationList() {
    if (_authenticationService.userRestaurant != null) {
      return _firestoreService.listenNotificationList(
        _authenticationService.userRestaurant.id,
      );
    } else {
      return _firestoreService.listenNotificationList(
        _authenticationService.currentUser.id,
      );
    }
  }

  void navToNotificationRoute(TasNotification notification) async {
    _navigationService.navigateTo(
      notification.navigationRoute,
      arguments: notification.navigationId,
    );

    if (!notification.seen) {
      await _firestoreService.setNofiticationSeen(notification.id);
    }
  }

  void deleteNotification(String notificationId) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Értesítés',
      content: Text('Biztos törölni szeretnéd az értesítést?'),
      confirmationTitle: 'Törlés',
      cancelTitle: 'Mégse',
    );

    if (dialogResponse.confirmed) {
      await _firestoreService.deleteNotification(notificationId);
    }
  }
}
