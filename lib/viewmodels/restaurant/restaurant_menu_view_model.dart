import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantMenuViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  Future getMenuItems() async {
    await _firestoreService.getMenuItems(
      _authenticationService.userRestaurant.id,
    );
  }
}
