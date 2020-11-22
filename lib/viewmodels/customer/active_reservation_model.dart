import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/models/reservation_with_restaurant_and_menuitems.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/dialog_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class ActiveReservationViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();

  final String reservationId;
  ActiveReservationViewModel({this.reservationId});

  Stream<ReservationWithRestaurantAndMenuItems>
      listenToReservationWithRestaurantAndMenuItems() {
    return _firestoreService.listenToReservationWithRestaurantAndMenuItems(
      reservationId,
    );
  }

  List<MenuItemWithQuantity> groupMenuItems(List<MenuItem> menuItems) {
    List<MenuItemWithQuantity> groupedMenuItems = [];

    menuItems.forEach((MenuItem menuItem) {
      bool inList = groupedMenuItems
              .where(
                (groupedMenuItem) => groupedMenuItem.menuItem.id == menuItem.id,
              )
              .length >
          0;

      if (inList) {
        int idx = groupedMenuItems.indexWhere(
          (groupedMenuItem) => groupedMenuItem.menuItem.id == menuItem.id,
        );
        groupedMenuItems[idx].quantity += 1;
      } else {
        groupedMenuItems
            .add(MenuItemWithQuantity(menuItem: menuItem, quantity: 1));
      }
    });

    return groupedMenuItems;
  }

  void setReservationStatusToPay() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Fizetés',
      description:
          'A foglalás le fog zárulni, ezután már több rendelést nem tudtok leadni.\n\nBiztos ezt szeretnétek?',
      confirmationTitle: 'Fizetés',
      cancelTitle: 'Mégse',
    );

    if (dialogResponse.confirmed) {
      await _firestoreService.setReservationStatusToPay(
        reservationId,
        _authService.currentUser.id,
      );
      await _authService.refreshUser();
    }
  }
}

class MenuItemWithQuantity {
  final MenuItem menuItem;
  int quantity;

  MenuItemWithQuantity({this.menuItem, this.quantity});
}
