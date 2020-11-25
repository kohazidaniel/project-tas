import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/views/customer/book_table_view.dart';
import 'package:tas/ui/views/restaurant/restaurant_menu_view.dart';
import 'package:tas/ui/widgets/star_rating.dart';
import 'package:tas/viewmodels/customer/place_details_view_model.dart';

List comments = [
  {
    "img": "assets/images/cm4.jpg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe"
  },
  {
    "img": "assets/images/cm4.jpg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Joe"
  },
  {
    "img": "assets/images/cm4.jpg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Mary Jane"
  },
  {
    "img": "assets/images/cm4.jpg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Jones"
  }
];

class PlaceDetailsView extends StatelessWidget {
  final String restaurantId;

  PlaceDetailsView({this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PlaceDetailsViewModel>.withConsumer(
      viewModel: PlaceDetailsViewModel(restaurantId: restaurantId),
      onModelReady: (model) => model.getViewData(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            FlutterI18n.translate(context, "details"),
            style: TextStyle(color: primaryColor),
          ),
          elevation: 0.0,
        ),
        body: model.restaurant == null && model.favouriteRestaurants == null
            ? Container()
            : Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 3.2,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              model.restaurant.thumbnailUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -10.0,
                          bottom: 3.0,
                          child: RawMaterialButton(
                            onPressed: () =>
                                model.addToFavourites(model.restaurant.id),
                            fillColor: Colors.white,
                            shape: CircleBorder(),
                            elevation: 4.0,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                model.favouriteRestaurants.contains(
                                  model.restaurant.id,
                                )
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      model.restaurant.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                      child: Row(
                        children: <Widget>[
                          SmoothStarRating(
                            starCount: 5,
                            color: Colors.yellow,
                            allowHalfRating: true,
                            rating: model.restaurant.ratings
                                    .reduce((a, b) => a + b) /
                                model.restaurant.ratings.length,
                            size: 11.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "${model.restaurant.ratings.reduce((a, b) => a + b) / model.restaurant.ratings.length} " +
                                "(${model.restaurant.ratings.length} ${FlutterI18n.translate(context, "review")})",
                            style: TextStyle(
                              fontSize: 11.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      model.restaurant.address,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      '${FlutterI18n.translate(context, 'opening_hours')}: ${model.restaurant.openingTime} - ${model.restaurant.closingTime}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      FlutterI18n.translate(context, "description"),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      model.restaurant.description,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          icon: Icon(Icons.event_seat),
          label: Text(FlutterI18n.translate(context, 'book_a_table')),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return BookTableView(restaurantId: model.restaurantId);
              }),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
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
                        restaurantId: model.restaurant.id,
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
