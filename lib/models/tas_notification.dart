import 'package:cloud_firestore/cloud_firestore.dart';

class TasNotification {
  final String id;
  final String userId;
  final String content;
  final String navigationRoute;
  final String navigationId;
  final bool seen;
  final Timestamp createDate;

  TasNotification({
    this.id,
    this.userId,
    this.content,
    this.navigationRoute,
    this.navigationId,
    this.seen,
    this.createDate,
  });

  TasNotification.fromData(Map<String, dynamic> data)
      : id = data['id'],
        userId = data['userId'],
        content = data['content'],
        navigationRoute = data['navigationRoute'],
        navigationId = data['navigationId'],
        seen = data['seen'],
        createDate = data['createDate'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'navigationRoute': navigationRoute,
      'navigationId': navigationId,
      'seen': seen,
      'createDate': createDate,
    };
  }
}
