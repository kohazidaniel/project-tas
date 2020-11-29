class Rating {
  final String userName;
  final int rating;
  final String comment;

  Rating({
    this.userName,
    this.rating,
    this.comment,
  });

  Rating.fromData(Map<String, dynamic> data)
      : userName = data['userName'],
        rating = data['rating'],
        comment = data['comment'];

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'rating': rating,
      'comment': comment,
    };
  }
}
