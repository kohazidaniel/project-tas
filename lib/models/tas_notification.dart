class TasNotification {
  final String id;
  final String userId;
  final String content;
  final String notificationAction;
  final int actionId;
  final bool seen;

  TasNotification({
    this.id,
    this.userId,
    this.content,
    this.notificationAction,
    this.actionId,
    this.seen,
  });

  TasNotification.fromData(Map<String, dynamic> data)
      : id = data['id'],
        userId = data['userId'],
        content = data['content'],
        notificationAction = data['notificationAction'],
        actionId = data['actionId'],
        seen = data['seen'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'notificationAction': notificationAction,
      'actionId': actionId,
      'seen': seen,
    };
  }
}
