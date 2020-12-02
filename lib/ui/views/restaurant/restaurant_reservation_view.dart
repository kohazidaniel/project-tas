import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/models/order_item.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_user.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/utils/datetime_utils.dart';
import 'package:tas/viewmodels/restaurant/restaurant_reservation_view_model.dart';

class RestaurantReservationView extends StatelessWidget {
  final String reservationId;

  RestaurantReservationView({this.reservationId});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantReservationViewModel>.reactive(
      viewModelBuilder: () => RestaurantReservationViewModel(
        reservationId: reservationId,
      ),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          centerTitle: true,
          title: Text(
            FlutterI18n.translate(context, 'reservation'),
            style: TextStyle(color: primaryColor),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 1.0,
        ),
        body: StreamBuilder<ReservationWithUser>(
          stream: model.listenToReservationWithUser(),
          builder: (
            BuildContext context,
            AsyncSnapshot<ReservationWithUser> snapshot,
          ) {
            if (snapshot.hasData) {
              List<OrderItem> groupedCompletedOrders = model.groupOrdersById(
                  snapshot.data.reservation.orders
                      .where((e) => e.completed)
                      .toList());
              List<OrderItem> pendingOrders = snapshot.data.reservation.orders
                  .where((e) => !e.completed)
                  .toList();

              return Scaffold(
                body: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 4.0,
                            child: ListTile(
                              title: Text(
                                snapshot.data.user.fullName,
                              ),
                              subtitle: Text(
                                DateTimeUtils.getFormattedDate(
                                  snapshot.data.reservation.reservationDate
                                      .toDate(),
                                ),
                              ),
                              trailing: model.getTrailing(
                                snapshot.data.reservation.status,
                              ),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/images/cm4.jpg",
                                ),
                                radius: 20.0,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          Visibility(
                            visible: pendingOrders.isNotEmpty,
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 4.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalSpaceSmall,
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20.0,
                                      ),
                                      child: Text(
                                        FlutterI18n.translate(
                                          context,
                                          'pending_orders',
                                        ),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    ...List.generate(
                                      pendingOrders.length,
                                      (int index) {
                                        OrderItem orderItem =
                                            pendingOrders[index];
                                        return ListTile(
                                          title: Text(
                                            orderItem.menuItem.name,
                                          ),
                                          subtitle: Text(
                                            '${orderItem.menuItem.price} ft x ${orderItem.quantity} ${FlutterI18n.translate(context, 'item')}',
                                          ),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                primaryColor.withOpacity(0.5),
                                            backgroundImage: NetworkImage(
                                              orderItem.menuItem.photoUrl,
                                            ),
                                          ),
                                          trailing: FlatButton(
                                            onPressed: () =>
                                                model.completeOrder(
                                              reservationId,
                                              orderItem.id,
                                            ),
                                            child: Text(
                                              FlutterI18n.translate(
                                                context,
                                                'fullfil',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          Visibility(
                            visible: groupedCompletedOrders.isNotEmpty,
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 4.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalSpaceSmall,
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20.0,
                                      ),
                                      child: Text(
                                        FlutterI18n.translate(
                                          context,
                                          'completed_orders',
                                        ),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    ...List.generate(
                                      groupedCompletedOrders.length,
                                      (int index) {
                                        OrderItem orderItem =
                                            groupedCompletedOrders[index];
                                        return ListTile(
                                          title: Text(
                                            orderItem.menuItem.name,
                                          ),
                                          subtitle: Text(
                                            '${orderItem.menuItem.price} ft',
                                          ),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                primaryColor.withOpacity(0.5),
                                            backgroundImage: NetworkImage(
                                              orderItem.menuItem.photoUrl,
                                            ),
                                          ),
                                          trailing: Text(
                                            '${orderItem.quantity} ${FlutterI18n.translate(context, 'item')}',
                                          ),
                                        );
                                      },
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${FlutterI18n.translate(context, 'total')}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data.reservation.total} Ft',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          snapshot.data.reservation.rating != null
                              ? Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 4.0,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 36.0,
                                      vertical: 16.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  FlutterI18n.translate(
                                                    context,
                                                    'review',
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                verticalSpaceTiny,
                                                Visibility(
                                                  visible: snapshot
                                                      .data
                                                      .reservation
                                                      .rating
                                                      .comment
                                                      .isNotEmpty,
                                                  child: Text(
                                                    "\"${snapshot.data.reservation.rating.comment}\"",
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${snapshot.data.reservation.rating.rating}",
                                                  style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 35.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
                floatingActionButton: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: snapshot.data.reservation.status ==
                          ReservationStatus.ACTIVE_PAYING
                      ? 45.0
                      : 0.0,
                  child: FloatingActionButton.extended(
                    elevation: 4.0,
                    icon: Icon(Icons.check),
                    label: Text(
                      FlutterI18n.translate(
                        context,
                        'close_reservation',
                      ),
                    ),
                    onPressed: () => model.closeReservation(
                      reservationId,
                      snapshot.data.user,
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: snapshot.data.reservation.status ==
                          ReservationStatus.ACTIVE_PAYING
                      ? 30.0
                      : 0.0,
                  child: BottomAppBar(
                    child: SizedBox.shrink(),
                    elevation: 8.0,
                  ),
                ),
              );
            } else {
              return BusyOverlay();
            }
          },
        ),
      ),
    );
  }
}
