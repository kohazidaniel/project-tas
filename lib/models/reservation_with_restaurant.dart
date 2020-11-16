import 'package:tas/models/reservation.dart';
import 'package:tas/models/restaurant.dart';

class ReservationWithRestaurant {
  final Reservation reservation;
  final Restaurant restaurant;

  ReservationWithRestaurant({this.reservation, this.restaurant});
}
