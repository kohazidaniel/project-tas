import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/ui/widgets/input_field.dart';
import 'package:tas/ui/widgets/text_link.dart';
import 'package:flutter/material.dart';
import 'package:tas/viewmodels/login_view_model.dart';
import 'package:flare_flutter/flare_actor.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: ViewModelBuilder<LoginViewModel>.reactive(
          viewModelBuilder: () => LoginViewModel(context),
          builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: FlareActor(
                            "assets/flare/beer_drink.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            animation: "normal",
                          ),
                        ),
                        Text(
                          'TAS',
                          style: TextStyle(
                              fontSize: 64, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    verticalSpaceTiny,
                    InputField(
                      placeholder: FlutterI18n.translate(context, "email"),
                      controller: emailController,
                      validationMessage: model.loginEmailErrorMessage,
                      textInputType: TextInputType.emailAddress,
                      nextFocusNode: passwordFocusNode,
                    ),
                    InputField(
                      placeholder: FlutterI18n.translate(context, "password"),
                      password: true,
                      controller: passwordController,
                      validationMessage: model.loginPasswordErrorMessage,
                      fieldFocusNode: passwordFocusNode,
                      enterPressed: () => model.login(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    ),
                    BusyButton(
                      title: FlutterI18n.translate(context, "login"),
                      busy: model.busy,
                      onPressed: () => model.login(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextLink(
                          FlutterI18n.translate(context, "signup"),
                          onPressed: () {
                            if (!model.busy) {
                              _navigationService
                                  .navigateTo(SignUpViewRoute)
                                  .then((_) => model.resetMessages());
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              )),
        ),
        onWillPop: () async => false);
  }
}
