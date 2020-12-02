import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/models/order_item.dart';
import 'package:tas/models/reservation_with_restaurant.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/views/restaurant/restaurant_menu_view.dart';
import 'package:tas/ui/widgets/blinking_point.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/viewmodels/customer/active_reservation_model.dart';

class ActiveReservationView extends StatelessWidget {
  final String reservationId;

  ActiveReservationView({this.reservationId});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveReservationViewModel>.reactive(
      viewModelBuilder: () =>
          ActiveReservationViewModel(reservationId: reservationId),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            FlutterI18n.translate(context, 'active_reservation'),
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: model.listenToReservationWithRestaurant(),
          builder: (
            BuildContext context,
            AsyncSnapshot<ReservationWithRestaurant> snapshot,
          ) {
            if (snapshot.hasData) {
              List<OrderItem> groupedCompletedOrders = model.groupOrdersById(
                snapshot.data.reservation.orders
                    .where((e) => e.completed)
                    .toList(),
              );
              List<OrderItem> groupedPendingOrders = model.groupOrdersById(
                snapshot.data.reservation.orders
                    .where((e) => !e.completed)
                    .toList(),
              );

              return Scaffold(
                backgroundColor: backgroundColor,
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
                                snapshot.data.restaurant.name,
                              ),
                              subtitle: Text(snapshot.data.restaurant.address),
                              trailing: BlinkingPoint(
                                xCoor: -10.0,
                                yCoor: 0.0,
                                pointColor: Colors.red,
                                pointSize: 10.0,
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  snapshot.data.restaurant.thumbnailUrl,
                                ),
                                radius: 20.0,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: snapshot.data.reservation.orders.isEmpty,
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
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width / 2,
                                      child: SvgPicture.asset(
                                        'assets/images/empty_reservation.svg',
                                      ),
                                    ),
                                    Text(
                                      FlutterI18n.translate(
                                        context,
                                        'no_orders',
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    verticalSpaceSmall,
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 36.0),
                                      child: BusyButton(
                                        title: FlutterI18n.translate(
                                          context,
                                          'view_menu_item_list',
                                        ),
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RestaurantMenuView(
                                                restaurantId:
                                                    snapshot.data.restaurant.id,
                                                reservationId: snapshot
                                                    .data.reservation.id,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
                                            '${orderItem.quantity} darab',
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: groupedPendingOrders.isNotEmpty,
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 4.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8.0,
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
                                      groupedPendingOrders.length,
                                      (int index) {
                                        OrderItem orderItem =
                                            groupedPendingOrders[index];
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                bottomNavigationBar: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  height:
                      snapshot.data.reservation.orders.isNotEmpty ? 55.0 : 0.0,
                  child: BottomAppBar(
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.menu_book,
                                color: Colors.grey[800],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return RestaurantMenuView(
                                      restaurantId: snapshot.data.restaurant.id,
                                      reservationId:
                                          snapshot.data.reservation.id,
                                    );
                                  }),
                                );
                              },
                            ),
                            horizontalSpaceMedium,
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '${FlutterI18n.translate(context, 'total')}: ',
                                  ),
                                  TextSpan(
                                    text:
                                        '${snapshot.data.reservation.total} Ft',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        horizontalSpaceMedium,
                        Visibility(
                          visible: groupedPendingOrders.isEmpty,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () => model.setReservationStatusToPay(
                              snapshot.data.reservation.total,
                              context,
                              snapshot.data.restaurant,
                            ),
                            color: primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              FlutterI18n.translate(context, 'pay')
                                  .toUpperCase(),
                            ),
                          ),
                        ),
                        horizontalSpaceTiny,
                      ],
                    ),
                  ),
                ),
              );
            }
            return BusyOverlay();
          },
        ),
      ),
    );
  }
}
