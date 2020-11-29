import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_user_and_menuitems.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/animated_button.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/viewmodels/customer/active_reservation_model.dart';
import 'package:tas/viewmodels/restaurant/restaurant_reservation_view_model.dart';

class RestaurantReservationView extends StatelessWidget {
  final String reservationId;

  RestaurantReservationView({this.reservationId});
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RestaurantReservationViewModel>.withConsumer(
      viewModel: RestaurantReservationViewModel(reservationId: reservationId),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          centerTitle: true,
          title: Text(
            'Asztalfoglalás',
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
        body: StreamBuilder<ReservationWithUserAndMenuItems>(
          stream: model.listenToReservationWithUserAndMenuItems(),
          builder: (
            BuildContext context,
            AsyncSnapshot<ReservationWithUserAndMenuItems> snapshot,
          ) {
            if (snapshot.hasData) {
              List<MenuItemWithQuantity> menuItemsWithQuantity =
                  model.groupMenuItems(
                snapshot.data.menuItems,
              );
              return ListView(
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
                              model.getFormattedDate(
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
                          visible: snapshot
                              .data.reservation.orderedMenuItemIds.isNotEmpty,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 4.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 20.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  menuItemsWithQuantity.length,
                                  (int index) {
                                    MenuItemWithQuantity menuItemWithQuantity =
                                        menuItemsWithQuantity[index];

                                    return Column(
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
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        ListTile(
                                          title: Text(
                                            menuItemWithQuantity.menuItem.name,
                                          ),
                                          subtitle: Text(
                                              '${menuItemWithQuantity.menuItem.price} ft'),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                primaryColor.withOpacity(0.5),
                                            backgroundImage: NetworkImage(
                                              menuItemWithQuantity
                                                  .menuItem.photoUrl,
                                            ),
                                          ),
                                          trailing: Text(
                                            '${menuItemWithQuantity.quantity} darab',
                                          ),
                                        ),
                                        const Divider(),
                                        Visibility(
                                          visible: index ==
                                              menuItemsWithQuantity.length - 1,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 24.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Végösszeg',
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
                                        ),
                                        Visibility(
                                          visible: snapshot
                                                  .data.reservation.status ==
                                              ReservationStatus.ACTIVE_PAYING,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              verticalSpaceMedium,
                                              AnimatedButton(
                                                onTap: () =>
                                                    model.closeReservation(
                                                  reservationId,
                                                ),
                                                animationDuration:
                                                    const Duration(
                                                  milliseconds: 1000,
                                                ),
                                                initialText:
                                                    "Fizetés jóváhagyása",
                                                finalText: "Fizetve",
                                                iconData: Icons.check,
                                                iconSize: 20.0,
                                                buttonStyle:
                                                    AnimatedButtonStyle(
                                                  primaryColor: primaryColor,
                                                  secondaryColor: Colors.white,
                                                  elevation: 10.0,
                                                  initialTextStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  finalTextStyle: TextStyle(
                                                    color: primaryColor,
                                                  ),
                                                  borderRadius: 10.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
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
                                                'Értékelés',
                                                style: TextStyle(
                                                  fontSize: 23,
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
                                                    fontStyle: FontStyle.italic,
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
