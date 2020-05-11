import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/navigation_service.dart';

import 'base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  BuildContext context;

  SignUpViewModel(BuildContext context) {
    this.context = context;
  }

  String signUpEmailErrorMessage;
  String signUpPasswordErrorMessage;
  String fullNameEmailErrorMessage;

  Future signUp({
    @required String email,
    @required String password,
    @required String fullName,
  }) async {
    resetMessages();

    setBusy(true);

    if (email.isEmpty || password.isEmpty) {
      if (email.isEmpty)
        signUpEmailErrorMessage = FlutterI18n.translate(
          context,
          "validation_messages.missing_email",
        );
      if (password.isEmpty)
        signUpPasswordErrorMessage = FlutterI18n.translate(
          context,
          "validation_messages.missing_password",
        );
      if (fullName.isEmpty)
        fullNameEmailErrorMessage = FlutterI18n.translate(
          context,
          "validation_messages.missing_full_name",
        );
      setBusy(false);
      return;
    }

    var result = await _authenticationService.signUpWithEmail(
      email: email.trim(),
      password: password,
      fullName: fullName,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(MainViewRoute);
      } else {
        signUpPasswordErrorMessage =
            FlutterI18n.translate(context, "validation_messages.default");
      }
    } else if (result is PlatformException) {
      switch (result.code) {
        case "ERROR_WEAK_PASSWORD":
          signUpPasswordErrorMessage = FlutterI18n.translate(
              context, "validation_messages.weak_password");
          break;
        case "ERROR_INVALID_EMAIL":
          signUpEmailErrorMessage = FlutterI18n.translate(
              context, "validation_messages.invalid_email");
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          signUpEmailErrorMessage = FlutterI18n.translate(
              context, "validation_messages.email_already_in_use");
          break;
        case "ERROR_INVALID_CREDENTIAL":
          signUpEmailErrorMessage = FlutterI18n.translate(
              context, "validation_messages.invalid_email");
          break;

        default:
          signUpPasswordErrorMessage = "An undefined Error happened.";
      }
    }
  }

  void resetMessages() {
    signUpEmailErrorMessage = null;
    signUpPasswordErrorMessage = null;
  }
}
