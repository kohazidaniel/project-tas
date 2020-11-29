import 'package:tas/models/menu_item.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/tas_user.dart';

class ReservationWithUserAndMenuItems {
  final Reservation reservation;
  final TasUser user;
  final List<MenuItem> menuItems;

  ReservationWithUserAndMenuItems({
    this.reservation,
    this.user,
    this.menuItems,
  });
}
