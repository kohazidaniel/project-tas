import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/user.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class ProfileViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();

  User getUser() {
    return _authService.currentUser;
  }

  void signOut() {
    _authService.signOut();
  }

  String getLanguage(BuildContext context) {
    switch (FlutterI18n.currentLocale(context).toString()) {
      case "hu":
        return FlutterI18n.translate(context, "hungarian");
      case "en":
        return FlutterI18n.translate(context, "english");
      default:
        return "Error";
    }
  }

  Future askForLang(BuildContext context) async {
    await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text(FlutterI18n.translate(context, "select_language")),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text(FlutterI18n.translate(context, "english")),
              onPressed: () async {
                await FlutterI18n.refresh(context, Locale("en"));
                Navigator.of(context, rootNavigator: true).pop();
                notifyListeners();
              },
            ),
            new SimpleDialogOption(
              child: new Text(FlutterI18n.translate(context, "hungarian")),
              onPressed: () async {
                await FlutterI18n.refresh(context, Locale("hu"));
                Navigator.of(context, rootNavigator: true).pop();
                notifyListeners();
              },
            ),
          ],
        ));
  }
}
