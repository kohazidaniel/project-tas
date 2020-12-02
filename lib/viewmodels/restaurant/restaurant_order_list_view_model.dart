import 'package:tas/locator.dart';
import 'package:tas/models/order_item.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantOrderListViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final String restaurantId;

  RestaurantOrderListViewModel({this.restaurantId});

  Stream<List<OrderItem>> listenToOrders() {
    return _firestoreService.listenToOrders(
      _authenticationService.userRestaurant.id,
    );
  }
}
