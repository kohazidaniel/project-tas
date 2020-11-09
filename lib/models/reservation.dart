import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String userId;
  final String restaurantId;
  final Timestamp reservationDate;
  final int numberOfPeople;
  final List<dynamic> orderMenuItemIds;
  final int total;
  final bool active;

  Reservation(
      {this.id,
      this.userId,
      this.restaurantId,
      this.reservationDate,
      this.numberOfPeople,
      this.total,
      this.orderMenuItemIds,
      this.active});

  Reservation.fromData(Map<String, dynamic> data)
      : id = data['id'],
        userId = data['userId'],
        restaurantId = data['restaurantId'],
        reservationDate = data['reservationDate'],
        numberOfPeople = data['numberOfPeople'],
        orderMenuItemIds = data['orderMenuItemIds'],
        total = data['total'],
        active = data['active'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'reservationDate': reservationDate,
      'numberOfPeople': numberOfPeople,
      'orderMenuItemIds': orderMenuItemIds,
      'total': total,
      'active': active
    };
  }
}
