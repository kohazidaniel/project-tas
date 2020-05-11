import 'package:tas/locator.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class NotificationViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  NavigationService get navigationService => _navigationService;
}
