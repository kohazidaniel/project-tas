import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

/// A modal overlay that will show over your child widget (fullscreen) when the show value is true
///
/// Wrap your scaffold in this widget and set show value to model.isBusy to show a loading modal when
/// your model state is Busy
class BusyOverlay extends StatelessWidget {
  final bool show;

  const BusyOverlay({
    this.show = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: FlareActor(
              "assets/flare/beer_drink.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "normal",
            ),
          ),
        ],
      ),
    );
  }
}
