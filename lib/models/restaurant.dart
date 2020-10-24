class Restaurant {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final List<dynamic> restaurantTypes;
  final String thumbnailUrl;
  final double latitude;
  final double longitude;
  final String address;

  Restaurant({
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.restaurantTypes,
    this.thumbnailUrl,
    this.latitude,
    this.longitude,
    this.address,
  });

  Restaurant.fromData(Map<String, dynamic> data)
      : id = data['id'],
        ownerId = data['ownerId'],
        name = data['name'],
        description = data['description'],
        restaurantTypes = data['restaurantTypes'],
        thumbnailUrl = data['thumbnailUrl'],
        latitude = data['latitude'],
        longitude = data['longitude'],
        address = data['address'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'restaurantTypes': restaurantTypes,
      'thumbnailUrl': thumbnailUrl,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}
