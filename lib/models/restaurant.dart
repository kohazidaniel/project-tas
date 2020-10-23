class Restaurant {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final List<String> restaurantTypes;
  final String thumbnail;

  Restaurant({
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.restaurantTypes,
    this.thumbnail,
  });

  Restaurant.fromData(Map<String, dynamic> data)
      : id = data['id'],
        ownerId = data['ownerId'],
        name = data['name'],
        description = data['description'],
        restaurantTypes = data['restaurantTypes'],
        thumbnail = data['thumbnail'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'restaurantTypes': restaurantTypes,
      'thumbnail': thumbnail,
    };
  }
}
