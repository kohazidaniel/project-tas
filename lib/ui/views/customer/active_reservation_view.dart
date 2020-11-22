import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:tas/models/reservation_with_restaurant_and_menuitems.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/views/restaurant/restaurant_menu_view.dart';
import 'package:tas/ui/widgets/blinking_point.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/viewmodels/customer/active_reservation_model.dart';

class ActiveReservationView extends StatelessWidget {
  final String reservationId;

  ActiveReservationView({this.reservationId});
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ActiveReservationViewModel>.withConsumer(
      viewModel: ActiveReservationViewModel(reservationId: reservationId),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: StreamBuilder(
          stream: model.listenToReservationWithRestaurantAndMenuItems(),
          builder: (
            BuildContext context,
            AsyncSnapshot<ReservationWithRestaurantAndMenuItems> snapshot,
          ) {
            if (snapshot.hasData) {
              List<MenuItemWithQuantity> menuItemsWithQuantity =
                  model.groupMenuItems(
                snapshot.data.menuItems,
              );

              return Scaffold(
                backgroundColor: Colors.grey[50],
                body: Builder(
                  builder: (context) => SliverFab(
                    floatingWidget: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return RestaurantMenuView(
                              restaurantId: snapshot.data.restaurant.id,
                              reservationId: snapshot.data.reservation.id,
                            );
                          }),
                        );
                      },
                      backgroundColor: backgroundColor,
                      child: Icon(
                        Icons.menu_book,
                        color: Colors.grey[800],
                      ),
                    ),
                    floatingPosition: FloatingPosition(right: 16),
                    expandedHeight: 150.0,
                    slivers: <Widget>[
                      SliverAppBar(
                        leading: IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: backgroundColor,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        expandedHeight: 150.0,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(snapshot.data.restaurant.name),
                          background: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  snapshot.data.restaurant.thumbnailUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 1.5,
                                sigmaY: 1.5,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          menuItemsWithQuantity.length == 0
                              ? [
                                  verticalSpaceExtraLarge,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: SvgPicture.asset(
                                          'assets/images/empty_reservation.svg',
                                        ),
                                      ),
                                      Text(
                                        'Még nem rendeltetek semmit',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            letterSpacing: 0.5,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Az ",
                                            ),
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.menu_book,
                                                color: Colors.grey[500],
                                                size: 20.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  " gombon keresztül eléritek az itallapot",
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ]
                              : List.generate(
                                  menuItemsWithQuantity.length,
                                  (int index) {
                                    MenuItemWithQuantity menuItemWithQuantity =
                                        menuItemsWithQuantity[index];

                                    return Padding(
                                        padding: EdgeInsets.only(
                                          top: index == 0 ? 15.0 : 0.0,
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              index == 0
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 20.0,
                                                      ),
                                                      child: Text(
                                                        'Rendelések',
                                                        style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              ListTile(
                                                title: Text(
                                                  menuItemWithQuantity
                                                      .menuItem.name,
                                                ),
                                                subtitle: Text(
                                                    "${menuItemWithQuantity.menuItem.price} ft"),
                                                leading: CircleAvatar(
                                                  backgroundColor: primaryColor
                                                      .withOpacity(0.5),
                                                  backgroundImage: NetworkImage(
                                                    menuItemWithQuantity
                                                        .menuItem.photoUrl,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  '${menuItemWithQuantity.quantity} darab',
                                                ),
                                              )
                                            ]));
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  height: menuItemsWithQuantity.length > 0 ? 55.0 : 0.0,
                  child: BottomAppBar(
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: [
                            BlinkingPoint(
                              pointColor: Colors.red,
                              pointSize: 8.0,
                              xCoor: 0.0,
                              yCoor: 0.0,
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
                                    text: 'Végösszeg: ',
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
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () => model.setReservationStatusToPay(),
                          color: primaryColor,
                          textColor: Colors.white,
                          child: Text(
                            "FIZETÉS",
                          ),
                        ),
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
