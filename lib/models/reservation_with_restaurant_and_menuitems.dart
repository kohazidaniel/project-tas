import 'package:tas/models/menu_item.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/restaurant.dart';

class ReservationWithRestaurantAndMenuItems {
  final Reservation reservation;
  final Restaurant restaurant;
  final List<MenuItem> menuItems;

  ReservationWithRestaurantAndMenuItems({
    this.reservation,
    this.restaurant,
    this.menuItems,
  });
}
