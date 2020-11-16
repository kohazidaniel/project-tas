import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/models/tas_user.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/utils/datetime_utils.dart';
import 'package:tas/viewmodels/base_model.dart';

class ProfileViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  TimeOfDay _openingTime;
  TimeOfDay get openingTime => _openingTime;

  TimeOfDay _closingTime;
  TimeOfDay get closingTime => _closingTime;

  TasUser getUser() {
    return _authService.currentUser;
  }

  Future<Restaurant> getRestaurant() async {
    Restaurant restaurant =
        await _firestoreService.getUserRestaurant(_authService.currentUser.id);

    _openingTime = DateTimeUtils.parseToTimeOfDay(restaurant.openingTime);
    _closingTime = DateTimeUtils.parseToTimeOfDay(restaurant.closingTime);

    return restaurant;
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
      ),
    );
  }

  Future<void> selectTime(
      {BuildContext context, bool isClosingTime = false}) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: isClosingTime ? _closingTime : _openingTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      if (isClosingTime) {
        _closingTime = picked;
      } else {
        _openingTime = picked;
      }
    }

    _firestoreService.updateOpeningHours(
      picked.format(context),
      _authService.userRestaurant.id,
      isClosingTime,
    );

    notifyListeners();
  }
}
