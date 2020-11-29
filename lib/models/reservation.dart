import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tas/models/rating.dart';

class Reservation {
  final String id;
  final String userId;
  final String restaurantId;
  final Timestamp reservationDate;
  final int numberOfPeople;
  final List<dynamic> orderedMenuItemIds;
  final int total;
  final String status;
  final Rating rating;

  Reservation({
    this.id,
    this.userId,
    this.restaurantId,
    this.reservationDate,
    this.numberOfPeople,
    this.total,
    this.orderedMenuItemIds,
    this.status,
    this.rating,
  });

  Reservation.fromData(Map<String, dynamic> data)
      : id = data['id'],
        userId = data['userId'],
        restaurantId = data['restaurantId'],
        reservationDate = data['reservationDate'],
        numberOfPeople = data['numberOfPeople'],
        orderedMenuItemIds = data['orderedMenuItemIds'],
        total = data['total'],
        status = data['status'],
        rating =
            data['rating'] != null ? Rating.fromData(data['rating']) : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'reservationDate': reservationDate,
      'numberOfPeople': numberOfPeople,
      'orderedMenuItemIds': orderedMenuItemIds,
      'total': total,
      'status': status,
      'rating': rating,
    };
  }
}

class ReservationStatus {
  static const UNSEEN_INACTIVE = "unseen_inactive";
  static const SEEN_INACTIVE = "seen_inactive";
  static const ACTIVE = "active";
  static const ACTIVE_PAYING = "active_paying";
  static const CLOSED = "closed";
  static const CANCELLED = "cancelled";
}
