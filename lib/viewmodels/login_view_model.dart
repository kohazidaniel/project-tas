import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/navigation_service.dart';

import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  BuildContext context;

  LoginViewModel(BuildContext context) {
    this.context = context;
  }

  String loginEmailErrorMessage;
  String loginPasswordErrorMessage;

  Future login({
    @required String email,
    @required String password,
  }) async {
    resetMessages();

    setBusy(true);

    if (email.isEmpty || password.isEmpty) {
      if (email.isEmpty)
        loginEmailErrorMessage = FlutterI18n.translate(
          context,
          "validation_messages.missing_email",
        );
      if (password.isEmpty)
        loginPasswordErrorMessage = FlutterI18n.translate(
          context,
          "validation_messages.missing_password",
        );
      setBusy(false);
      return;
    }

    var result = await _authenticationService.loginWithEmail(
      email: email.trim(),
      password: password,
    );

    print(result);

    setBusy(false);

    if (result is bool && result) {
      if (result) {
        _navigationService.navigateTo(StartUpViewRoute);
      } else {
        loginPasswordErrorMessage = FlutterI18n.translate(
          context,
          "validation_messages.default",
        );
      }
    } else {
      switch (result.code) {
        case "invalid-email":
          loginEmailErrorMessage = FlutterI18n.translate(
            context,
            "validation_messages.invalid_email",
          );
          break;
        case "wrong-password":
          loginPasswordErrorMessage = FlutterI18n.translate(
            context,
            "validation_messages.wrong_password",
          );
          break;
        case "user-not-found":
          loginEmailErrorMessage = FlutterI18n.translate(
            context,
            "validation_messages.user_not_found",
          );
          break;
        default:
          loginPasswordErrorMessage = FlutterI18n.translate(
            context,
            "validation_messages.default",
          );
      }
    }
  }

  void resetMessages() {
    loginEmailErrorMessage = null;
    loginPasswordErrorMessage = null;
  }
}
