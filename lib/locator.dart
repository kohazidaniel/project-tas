import 'package:get_it/get_it.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/cloud_storage_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/services/dialog_service.dart';
import 'package:tas/services/push_notification_service.dart';
import 'package:tas/viewmodels/restaurant/restaurant_reservations_list_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => PushNotificationService());

  // ViewModels
  locator.registerLazySingleton(() => RestaurantReservationsListViewModel());
}
