import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/viewmodels/customer/book_table_view_model.dart';

class BookTableView extends StatelessWidget {
  final String restaurantId;

  BookTableView({this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BookTableViewModel>.withConsumer(
      viewModel: BookTableViewModel(restaurantId: restaurantId),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: FutureBuilder<Restaurant>(
            future: model.getRestaurant(),
            builder:
                (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
              if (snapshot.hasData) {
                return ListView(
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
                                      snapshot.data.thumbnailUrl,
                                    ),
                                    radius: 20.0,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                  horizontalSpaceSmall,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        snapshot.data.name,
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
                          verticalSpaceLarge,
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 2.5,
                            child: SvgPicture.asset(
                              'assets/images/book_a_table.svg',
                            ),
                          ),
                          verticalSpaceLarge,
                          Row(
                            children: [
                              Text(
                                FlutterI18n.translate(
                                  context,
                                  'book_table_view.number_of_people_title',
                                ),
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${model.numberOfPeople.toString()} ${FlutterI18n.translate(context, 'book_table_view.people')}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              Row(
                                children: [
                                  FloatingActionButton(
                                    onPressed: () =>
                                        model.decreaseNumberOfPeople(),
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    disabledElevation: 0.0,
                                    child: Icon(
                                      Icons.remove,
                                      size: 16.0,
                                      color: primaryColor,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    onPressed: () =>
                                        model.increaseNumberOfPeople(),
                                    mini: true,
                                    child: Icon(
                                      Icons.add,
                                      size: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          verticalSpaceSmall,
                          Row(
                            children: [
                              Text(
                                FlutterI18n.translate(
                                  context,
                                  'book_table_view.which_day_title',
                                ),
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model.getFormattedDate(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              FlatButton(
                                child: Text(
                                  FlutterI18n.translate(
                                    context,
                                    'book_table_view.select_day',
                                  ),
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                textColor: primaryColor,
                                onPressed: () => model.selectDate(context),
                              ),
                            ],
                          ),
                          verticalSpaceSmall,
                          Row(
                            children: [
                              Text(
                                FlutterI18n.translate(
                                  context,
                                  'book_table_view.when_title',
                                ),
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model.selectedTime?.format(context) ??
                                    snapshot.data.openingTime,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              FlatButton(
                                child: Text(
                                  FlutterI18n.translate(
                                    context,
                                    'book_table_view.select_time',
                                  ),
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                textColor: primaryColor,
                                onPressed: () => model.selectTime(context),
                              ),
                            ],
                          ),
                          verticalSpaceSmall,
                          BusyButton(
                            title: FlutterI18n.translate(
                              context,
                              'book_table_view.book',
                            ),
                            onPressed: () => model.createReservation(context),
                            busy: model.busy,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
