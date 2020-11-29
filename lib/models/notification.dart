class Notification {
  final String id;
  final String userId;
  final String content;
  final String notificationType;
  final String navigationId;

  Notification({
    this.id,
    this.userId,
    this.content,
    this.notificationType,
    this.navigationId,
  });

  Notification.fromData(Map<String, dynamic> data)
      : id = data['id'],
        userId = data['userId'],
        content = data['content'],
        notificationType = data['notificationType'],
        navigationId = data['navigationId'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'notificationType': notificationType,
      'navigationId': navigationId,
    };
  }
}
