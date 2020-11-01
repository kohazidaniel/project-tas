import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tas/locator.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/ui/widgets/expansion_list.dart';
import 'package:tas/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/widgets/text_link.dart';
import 'package:tas/viewmodels/signup_view_model.dart';

import '../../services/navigation_service.dart';
import '../shared/ui_helpers.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>.withConsumer(
      viewModel: SignUpViewModel(context),
      builder: (context, model, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                FlutterI18n.translate(context, "signup"),
                style: TextStyle(
                  fontSize: 38,
                ),
              ),
              verticalSpaceMedium,
              InputField(
                placeholder: FlutterI18n.translate(context, "full_name"),
                controller: fullNameController,
                validationMessage: model.fullNameEmailErrorMessage,
                nextFocusNode: model.emailNode,
              ),
              InputField(
                placeholder: FlutterI18n.translate(context, "email"),
                controller: emailController,
                validationMessage: model.signUpEmailErrorMessage,
                fieldFocusNode: model.emailNode,
                nextFocusNode: model.passwordNode,
              ),
              InputField(
                placeholder: FlutterI18n.translate(context, "password"),
                password: true,
                controller: passwordController,
                validationMessage: model.signUpPasswordErrorMessage,
                fieldFocusNode: model.passwordNode,
                enterPressed: () => model.passwordNode.unfocus(),
              ),
              ExpansionList<String>(
                items: model.selectableRoles,
                title: model.selectedRole,
                onItemSelected: model.setSelectedRole,
              ),
              verticalSpaceMedium,
              BusyButton(
                title: FlutterI18n.translate(context, "signup"),
                busy: model.busy,
                onPressed: () {
                  if (!model.busy) {
                    model.signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      fullName: fullNameController.text,
                    );
                  }
                },
              ),
              verticalSpaceMedium,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextLink(
                    FlutterI18n.translate(context, "back"),
                    onPressed: () {
                      if (!model.busy) {
                        _navigationService.pop();
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
