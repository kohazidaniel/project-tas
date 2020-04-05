import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/viewmodels/howe_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: ViewModelProvider<HomeViewModel>.withConsumer(
          viewModel: HomeViewModel(),
          builder: (context, model, child) => Scaffold(
              body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      BusyButton(
                          title: 'Sign Out',
                          onPressed: () {
                            model.signOut();
                          })
                    ],
                  )))),
      onWillPop: () async => false,
    );
  }
}
