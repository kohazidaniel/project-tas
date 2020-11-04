import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class FavouriteViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  List<Restaurant> _restaurants;
  List<Restaurant> get restaurants => _restaurants;

  List<String> _favouriteRestaurants;
  List<String> get favouriteRestaurants => _favouriteRestaurants;

  void getViewData() async {
    _restaurants = await _firestoreService.getRestaurants();

    notifyListeners();
  }
}
