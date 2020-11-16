import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_restaurant.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/viewmodels/customer/cart_view_model.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CartViewModel>.withConsumer(
      viewModel: CartViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: StreamBuilder<List<ReservationWithRestaurant>>(
            stream: model.listenToUserReservations(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<ReservationWithRestaurant>> snapshot,
            ) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_seat,
                          size: 64.0,
                          color: Colors.grey[400],
                        ),
                        Text(
                          'Még nincsen foglalásod',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Reservation reservation =
                          snapshot.data[index].reservation;
                      Restaurant restaurant = snapshot.data[index].restaurant;

                      return ListTile(
                        title: Text(restaurant.name),
                        subtitle: Text(model.getFormattedDate(
                          reservation.reservationDate.toDate(),
                        )),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            restaurant.thumbnailUrl,
                          ),
                        ),
                        onTap: () => model.navToReservationDetails(
                          reservation.id,
                        ),
                        trailing: reservation.seen
                            ? SizedBox.shrink()
                            : Container(
                                padding: EdgeInsets.all(1),
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  maxWidth: 12,
                                  maxHeight: 12,
                                ),
                              ),
                      );
                    },
                  );
                }
              } else {
                return BusyOverlay(
                  show: true,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
