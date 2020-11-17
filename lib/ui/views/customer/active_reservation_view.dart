import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/viewmodels/customer/active_reservarion_model.dart';

class ActiveReservationView extends StatelessWidget {
  final String reservationId;

  ActiveReservationView({this.reservationId});
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ActiveReservationViewModel>.withConsumer(
      viewModel: ActiveReservationViewModel(reservationId: reservationId),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
      ),
    );
  }
}
