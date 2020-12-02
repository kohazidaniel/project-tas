import 'package:animations/animations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/reservation_with_user.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/views/notification_view.dart';
import 'package:tas/ui/views/profile_view.dart';
import 'package:tas/ui/views/restaurant/restaurant_menu_view.dart';
import 'package:tas/ui/views/restaurant/restaurant_reservations_list_view.dart';
import 'package:tas/ui/widgets/badge.dart';
import 'package:tas/ui/widgets/blinking_point.dart';
import 'package:tas/utils/datetime_utils.dart';
import 'package:tas/viewmodels/restaurant/restaurant_main_view_model.dart';

class RestaurantMainView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: ViewModelBuilder<RestaurantMainViewModel>.reactive(
        viewModelBuilder: () => RestaurantMainViewModel(),
        onModelReady: (model) {
          model.getUserRestaurant();
        },
        builder: (context, model, child) => Scaffold(
          backgroundColor: backgroundColor,
          key: _drawerKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 35,
                  width: 35,
                  child: FlareActor(
                    "assets/flare/beer_drink.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "normal",
                  ),
                ),
                Text(
                  'TAS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.menu_rounded),
              color: Colors.black,
              onPressed: () {
                _drawerKey.currentState.openDrawer();
              },
            ),
            backgroundColor: backgroundColor,
            elevation: 0.0,
            actions: <Widget>[
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                openBuilder: (BuildContext context, VoidCallback _) {
                  return NotificationView();
                },
                closedElevation: 0.0,
                closedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50 / 2),
                  ),
                ),
                openColor: primaryColor,
                closedBuilder: (
                  BuildContext context,
                  VoidCallback openContainer,
                ) {
                  return StreamBuilder<int>(
                    stream: model.listenToUnSeenNotificationListLength(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<int> snapshot,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: IconBadge(
                          icon: Icons.notifications,
                          size: 22.0,
                          badgeValue: snapshot.hasData ? snapshot.data : 0,
                          color: primaryColor,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    StreamBuilder<List<ReservationWithUser>>(
                      stream: model.listenToRestaurantReservations(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<List<ReservationWithUser>> snapshot,
                      ) {
                        if (snapshot.hasData) {
                          List<ReservationWithUser> activeReservations =
                              snapshot.data
                                  .where((e) =>
                                      e.reservation.status ==
                                      ReservationStatus.ACTIVE)
                                  .toList();

                          if (activeReservations.isNotEmpty) {
                            return Card(
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
                                        left: 16.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Aktív foglalások',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          BlinkingPoint(
                                            xCoor: -30.0,
                                            yCoor: 0.0,
                                            pointColor: Colors.red,
                                            pointSize: 10.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    verticalSpaceSmall,
                                    ...List.generate(
                                      activeReservations.length,
                                      (int index) {
                                        ReservationWithUser
                                            reservationWithUser =
                                            activeReservations[index];
                                        return ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          title: Text(
                                            reservationWithUser.user.fullName,
                                          ),
                                          subtitle: Text(
                                            DateTimeUtils.getFormattedDate(
                                              reservationWithUser
                                                  .reservation.reservationDate
                                                  .toDate(),
                                            ),
                                          ),
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage(
                                              "assets/images/cm4.jpg",
                                            ),
                                            radius: 20.0,
                                            backgroundColor: Colors.grey[200],
                                          ),
                                          onTap: () => model.navToReservation(
                                            reservationWithUser.reservation.id,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 100,
                  child: DrawerHeader(
                    child: model.userRestaurant != null
                        ? InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ProfileView();
                                }),
                              );
                            },
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    model.userRestaurant.thumbnailUrl,
                                  ),
                                  radius: 20.0,
                                  backgroundColor: Colors.grey[200],
                                ),
                                horizontalSpaceSmall,
                                Flexible(
                                  child: Text(
                                    model.userRestaurant.name,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    FlutterI18n.translate(context, 'profile'),
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ProfileView();
                      }),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.menu_book,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    FlutterI18n.translate(context, 'drink_menu'),
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return RestaurantMenuView();
                      }),
                    );
                  },
                ),
                ListTile(
                  leading: IconBadge(
                    icon: Icons.event_seat,
                    color: Colors.grey[800],
                  ),
                  title: Text(
                    FlutterI18n.translate(context, 'book_a_table'),
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return RestaurantReservationsListView();
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
