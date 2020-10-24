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
    this._selectableRoles = ['Vendég', 'Vendéglátóhely'];
    this._selectedRole = _selectableRoles[0];
  }

  List<String> _selectableRoles;
  List<String> get selectableRoles => _selectableRoles;
  String _selectedRole;
  String get selectedRole => _selectedRole;

  void setSelectedRole(dynamic role) {
    _selectedRole = role;
    notifyListeners();
  }

  String signUpEmailErrorMessage = "";
  String signUpPasswordErrorMessage = "";
  String fullNameEmailErrorMessage = "";

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

    var userRoleValue = _selectedRole == 'Vendég' ? 'CUSTOMER' : 'RESTAURANT';

    var result = await _authenticationService.signUpWithEmail(
      email: email.trim(),
      password: password,
      fullName: fullName,
      userRole: userRoleValue,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(StartUpViewRoute);
      } else {
        signUpPasswordErrorMessage = FlutterI18n.translate(
          context,
          "validation_messages.default",
        );
      }
    } else {
      switch (result.code) {
        case "weak-password":
          signUpPasswordErrorMessage = FlutterI18n.translate(
            context,
            "validation_messages.weak_password",
          );
          break;
        case "invalid-email":
          signUpEmailErrorMessage = FlutterI18n.translate(
            context,
            "validation_messages.invalid_email",
          );
          break;
        case "email-already-in-use":
          signUpEmailErrorMessage = FlutterI18n.translate(
            context,
            "validation_messages.email_already_in_use",
          );
          break;
        default:
          signUpPasswordErrorMessage = "An undefined Error happened.";
      }
    }
  }

  void resetMessages() {
    signUpEmailErrorMessage = "";
    signUpPasswordErrorMessage = "";
    fullNameEmailErrorMessage = "";
  }
}
