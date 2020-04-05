import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class HomeViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();

  void signOut() {
    _authService.signOut();
  }
}
