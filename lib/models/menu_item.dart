class MenuItem {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String menuItemType;
  final int price;
  final String restaurantId;

  MenuItem({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.menuItemType,
    this.price,
    this.restaurantId,
  });

  MenuItem.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        description = data['description'],
        photoUrl = data['photoUrl'],
        menuItemType = data['menuItemType'],
        price = data['price'],
        restaurantId = data['restaurantId'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'menuItemType': menuItemType,
      'price': price,
      'restaurantId': restaurantId,
    };
  }
}
