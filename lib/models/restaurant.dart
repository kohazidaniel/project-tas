class Restaurant {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String thumbnailUrl;
  final List<dynamic> restaurantTypes;
  final List<dynamic> ratings;
  final double latitude;
  final double longitude;
  final String address;
  final String openingTime;
  final String closingTime;
  final String fcmToken;

  Restaurant(
      {this.id,
      this.ownerId,
      this.name,
      this.description,
      this.restaurantTypes,
      this.ratings,
      this.thumbnailUrl,
      this.latitude,
      this.longitude,
      this.address,
      this.openingTime,
      this.closingTime,
      this.fcmToken});

  Restaurant.fromData(Map<String, dynamic> data)
      : id = data['id'],
        ownerId = data['ownerId'],
        name = data['name'],
        description = data['description'],
        restaurantTypes = data['restaurantTypes'],
        ratings = data['ratings'],
        thumbnailUrl = data['thumbnailUrl'],
        latitude = data['latitude'],
        longitude = data['longitude'],
        address = data['address'],
        openingTime = data['openingTime'],
        closingTime = data['closingTime'],
        fcmToken = data['fcmToken'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'restaurantTypes': restaurantTypes,
      'ratings': ratings,
      'thumbnailUrl': thumbnailUrl,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'fcmToken': fcmToken,
    };
  }
}
