import 'package:tas/models/reservation.dart';
import 'package:tas/models/tas_user.dart';

class ReservationWithUser {
  final Reservation reservation;
  final TasUser user;

  ReservationWithUser({this.reservation, this.user});
}
