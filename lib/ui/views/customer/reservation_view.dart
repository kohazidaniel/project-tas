import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/utils/datetime_utils.dart';
import 'package:tas/viewmodels/customer/reservation_view_model.dart';
import 'package:stacked/stacked.dart';

class ReservationView extends StatelessWidget {
  final String reservationId;

  ReservationView({this.reservationId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReservationViewModel>.reactive(
      viewModelBuilder: () => ReservationViewModel(reservationId),
      onModelReady: (model) => model.getReservation(),
      builder: (context, model, child) => Scaffold(
        body: model.reservation == null || model.restaurant == null
            ? BusyOverlay()
            : Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onTap: () => model.navToPlaceDetailsView(
                            model.restaurant.id,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
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
                                      FlutterI18n.translate(
                                        context,
                                        'book_a_table',
                                      ),
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
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: primaryColor,
                          ),
                          onPressed: () => model.navToBack(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 2,
                      child: SvgPicture.asset(
                        'assets/images/book_a_table.svg',
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FlutterI18n.translate(context, 'status'),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  FlutterI18n.translate(
                                    context,
                                    'reservationStatus.${model.reservation.status}',
                                  ),
                                )
                              ],
                            ),
                            model.reservation.status ==
                                        ReservationStatus.ACTIVE_PAYING ||
                                    model.reservation.status ==
                                        ReservationStatus.CLOSED
                                ? Row(
                                    children: [
                                      Text(
                                        '${model.reservation.total} Ft',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FlutterI18n.translate(context, 'date'),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateTimeUtils.getFormattedDate(
                                    model.reservation.reservationDate.toDate(),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${model.reservation.numberOfPeople}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.person),
                              ],
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        model.canStartReservation()
                            ? BusyButton(
                                title: FlutterI18n.translate(
                                  context,
                                  'we_are_here',
                                ),
                                onPressed: () => model.startReservation(),
                              )
                            : SizedBox.shrink(),
                        verticalSpaceSmall,
                        model.canDeleteReservation()
                            ? BusyButton(
                                title: FlutterI18n.translate(
                                  context,
                                  'delete',
                                ),
                                onPressed: () => model.deleteReservation(),
                              )
                            : SizedBox.shrink(),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
