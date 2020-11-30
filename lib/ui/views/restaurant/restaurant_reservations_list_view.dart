import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/reservation_with_user.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/badge.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/ui/views/restaurant/restaurant_reservations_list_filter_view.dart';
import 'package:tas/viewmodels/restaurant/restaurant_reservations_list_view_model.dart';

class RestaurantReservationsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantReservationsListViewModel>.reactive(
      viewModelBuilder: () => locator<RestaurantReservationsListViewModel>(),
      disposeViewModel: false,
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          centerTitle: true,
          title: Text(
            'Asztalfoglalások',
            style: TextStyle(color: primaryColor),
          ),
          actions: <Widget>[
            OpenContainer(
              transitionType: ContainerTransitionType.fadeThrough,
              openBuilder: (BuildContext context, VoidCallback _) {
                return RestaurantReservationsListFilterView();
              },
              closedElevation: 0.0,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50 / 2),
                ),
              ),
              openColor: primaryColor,
              closedBuilder:
                  (BuildContext context, VoidCallback openContainer) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: IconBadge(
                    icon: Icons.filter_list,
                    size: 22.0,
                    badgeValue: 0,
                    color: primaryColor,
                  ),
                );
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 1.0,
        ),
        body: StreamBuilder<List<ReservationWithUser>>(
          stream: model.listenToRestaurantReservations(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<ReservationWithUser>> snapshot,
          ) {
            if (snapshot.hasData) {
              return Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: false,
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Név',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Státusz',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Fizetendő',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Dátum',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Fő',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Értékelés',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: snapshot.data.where(
                        (ReservationWithUser reservationWithUser) {
                          return model.filterReservation(reservationWithUser);
                        },
                      ).map((ReservationWithUser reservationWithUser) {
                        return DataRow(
                          onSelectChanged: (value) => model.navToReservation(
                            reservationWithUser.reservation.id,
                          ),
                          cells: <DataCell>[
                            DataCell(Text(reservationWithUser.user.fullName)),
                            DataCell(
                              Text(
                                FlutterI18n.translate(
                                  context,
                                  'reservationStatus.${reservationWithUser.reservation.status}',
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                "${reservationWithUser.reservation.total} Ft",
                              ),
                            ),
                            DataCell(
                              Text(
                                model.getFormattedDate(
                                  reservationWithUser
                                      .reservation.reservationDate
                                      .toDate(),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                  '${reservationWithUser.reservation.numberOfPeople}'),
                            ),
                            DataCell(
                              reservationWithUser.reservation.rating != null
                                  ? Row(
                                      children: [
                                        Text(
                                          '${reservationWithUser.reservation.rating.rating}',
                                        ),
                                        Icon(
                                          Icons.star,
                                          size: 16.0,
                                          color: Colors.yellow,
                                        ),
                                      ],
                                    )
                                  : Text('Nincs értékelve'),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            } else {
              return BusyOverlay(
                show: true,
              );
            }
          },
        ),
      ),
    );
  }
}
