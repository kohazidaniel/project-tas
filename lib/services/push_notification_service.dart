import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:tas/locator.dart';
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
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _serialiseAndNavigate(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _serialiseAndNavigate(message);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      // Navigate to the create post view
      if (view == 'create_post') {
        print('hello');
      }
    }
  }

  Future<void> sendAndRetrieveMessage() async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await _fcm.getToken(),
        },
      ),
    );
  }

  Future<String> getFcmToken() async {
    return await _fcm.getToken();
  }
}
