import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/viewmodels/startup_view_model.dart';

class StartUpView extends StatelessWidget {
  final bool isNewRestaurant;
  const StartUpView({Key key, this.isNewRestaurant = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
      viewModel: StartUpViewModel(),
      onModelReady: (model) {
        model.setIsNewRestaurant(isNewRestaurant);
        model.handleStartUpLogic();
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
