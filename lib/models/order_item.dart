import 'package:tas/models/menu_item.dart';

class OrderItem {
  final String id;
  final String reservationId;
  final MenuItem menuItem;
  int quantity;
  bool completed;

  OrderItem({
    this.id,
    this.reservationId,
    this.menuItem,
    this.quantity,
    this.completed,
  });

  OrderItem.fromData(Map<String, dynamic> data)
      : id = data['id'],
        reservationId = data['reservationId'],
        menuItem = MenuItem.fromData(data['menuItem']),
        quantity = data['quantity'],
        completed = data['completed'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservationId': reservationId,
      'menuItem': menuItem.toJson(),
      'quantity': quantity,
      'completed': completed,
    };
  }
}
