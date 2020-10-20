import 'dart:developer';

import 'package:tas/viewmodels/base_model.dart';

class NewRestaurantStepperViewModel extends BaseModel {
  int get currStep => _currStep;
  int _currStep = 0;

  int get totalSteps => _totalSteps;
  int _totalSteps = 2;

  String restaurantNameErrorMessage;
  String restaurantPhoneErrorMessage;

  void onStepContinue() {
    if (_currStep < _totalSteps) {
      _currStep += 1;
    } else {
      _currStep = 0;
    }
    notifyListeners();
  }

  // ignore: missing_return
  Future<bool> onStepCancel() {
    if (_currStep > 0) _currStep -= 1;
    notifyListeners();
  }

  void onStepTapped(step) {
    _currStep = step;
    notifyListeners();
  }

  void createRestaurant(
    String restaurantName,
    String restaurantPhone,
  ) {
    resetMessages();
    RegExp regExp = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

    if (restaurantName.isEmpty) {
      _currStep = 0;
      restaurantNameErrorMessage = "Hiányos mező";
      notifyListeners();
      return;
    }

    if (restaurantPhone.isEmpty) {
      _currStep = 1;
      restaurantPhoneErrorMessage = "Hiányos mező";
      notifyListeners();
      return;
    }

    if (!regExp.hasMatch(restaurantPhone)) {
      _currStep = 1;
      restaurantPhoneErrorMessage = "Helytelen formátum";
      notifyListeners();
      return;
    }

    log(restaurantName + "\n" + restaurantPhone);
  }

  void resetMessages() {
    restaurantNameErrorMessage = "";
    restaurantPhoneErrorMessage = "";
  }
}
