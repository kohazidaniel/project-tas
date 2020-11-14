import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/viewmodels/customer/reservation_view_model.dart';

class ReservationView extends StatelessWidget {
  final String reservationId;

  ReservationView({this.reservationId});
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ReservationViewModel>.withConsumer(
      viewModel: ReservationViewModel(reservationId),
      onModelReady: (model) => model.getReservation(),
      builder: (context, model, child) => Scaffold(
        body: model.reservation == null || model.restaurant == null
            ? BusyOverlay()
            : ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    model.restaurant.thumbnailUrl,
                                  ),
                                  radius: 20.0,
                                  backgroundColor: Colors.grey[200],
                                ),
                                horizontalSpaceSmall,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Asztalfoglalás',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      model.restaurant.name,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: primaryColor,
                              ),
                              onPressed: () => model.navigationService.pop(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
