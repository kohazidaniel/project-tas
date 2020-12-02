import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:tas/locator.dart';
import 'package:tas/models/tas_notification.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final String serverToken =
      'AAAAn62jiK8:APA91bH39VoLJnaBtCAzDbVyDE1MTLFbBrTMXJbm0usfTs5X-OR8yMGfZxPYN9BNc2mTjKyLCp7nNL5AEkqM_7yAbC5T3Xjou1s78aPArJxxhF-iapUuyE_T1Ib1IPJY13x2Kpe9BHz8';
  final NavigationService _navigationService = locator<NavigationService>();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {
        _serialiseAndNavigate(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _serialiseAndNavigate(message);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) async {
    var notificationData = message['data'];

    _navigationService.navigateTo(
      notificationData['navigationRoute'],
      arguments: notificationData['navigationId'],
    );
  }

  Future<void> sendAndPushNotification(
    TasNotification notification,
    String fcmToken,
  ) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': notification.content,
            'title': 'Új értesítés'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'navigationRoute': notification.navigationRoute,
            'navigationId': notification.navigationId,
          },
          'to': fcmToken,
        },
      ),
    );
  }

  Future<String> getFcmToken() async {
    return await _fcm.getToken();
  }
}
