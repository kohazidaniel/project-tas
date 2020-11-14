class TasUser {
  final String id;
  final String fullName;
  final String email;
  final String userRole;
  final List<dynamic> favouriteRestaurants;

  TasUser({
    this.id,
    this.fullName,
    this.email,
    this.userRole,
    this.favouriteRestaurants,
  });

  TasUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        userRole = data['userRole'],
        favouriteRestaurants = data['favouriteRestaurants'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
      'favouriteRestaurants': favouriteRestaurants,
    };
  }
}
