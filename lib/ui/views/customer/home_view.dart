import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/blinking_point.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/ui/widgets/category_card.dart';
import 'package:tas/ui/widgets/grid_card.dart';
import 'package:tas/ui/widgets/slider_item.dart';
import 'package:tas/viewmodels/customer/home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      onModelReady: (model) => model.getViewData(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: model.restaurants == null || model.currentPosition == null
              ? BusyOverlay()
              : ListView(
                  children: <Widget>[
                    StreamBuilder(
                      stream: model.listenToUserReservationInProgress(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<bool> snapshot,
                      ) {
                        if (snapshot.hasData) {
                          if (snapshot.data) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      FlutterI18n.translate(
                                        context,
                                        "active_reservation",
                                      ),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceTiny,
                                Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 4.0,
                                  child: ListTile(
                                    title: Text(
                                      model.reservationWithRestaurant.restaurant
                                          .name,
                                    ),
                                    subtitle: Text(
                                      model.reservationWithRestaurant.restaurant
                                          .address,
                                    ),
                                    trailing: BlinkingPoint(
                                      xCoor: -10.0,
                                      yCoor: 0.0,
                                      pointColor: Colors.red,
                                      pointSize: 10.0,
                                    ),
                                    leading: CircleAvatar(
                                      maxRadius: 24,
                                      backgroundImage: NetworkImage(
                                        model.reservationWithRestaurant
                                            .restaurant.thumbnailUrl,
                                      ),
                                    ),
                                    onTap: () =>
                                        model.navToActiveReservationView(
                                      model.reservationWithRestaurant
                                          .reservation.id,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                    verticalSpaceTiny,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, "recommended_places"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceTiny,
                    CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 2.4,
                        viewportFraction: 1.0,
                        autoPlay: false,
                      ),
                      items: model.restaurants
                          .map(
                            (restaurant) => SliderItem(
                              name: restaurant.name,
                              img: restaurant.thumbnailUrl,
                              restaurantId: restaurant.id,
                              favTap: () =>
                                  model.addToFavourites(restaurant.id),
                              isFav: model.favouriteRestaurants
                                  .contains(restaurant.id),
                            ),
                          )
                          .toList(),
                    ),
                    verticalSpaceSmall,
                    Text(
                      FlutterI18n.translate(context, "categories"),
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      height: 65.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: model.getRestaurantTypes().length,
                        itemBuilder: (BuildContext context, int index) {
                          Map cat = model.getRestaurantTypes()[index];
                          return CategoryCard(
                            icon: cat['icon'],
                            title: FlutterI18n.translate(
                              context,
                              'restaurantTypes.${cat['name']}',
                            ),
                            items: cat['items'].toString(),
                            tap: () => model.navToListByCategoriesView(
                              cat['name'],
                            ),
                          );
                        },
                      ),
                    ),
                    verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, "places_nearby"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    verticalSpaceTiny,
                    GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.25),
                      ),
                      itemCount: model.getNearbyRestaurants().length,
                      itemBuilder: (BuildContext context, int index) {
                        List<Restaurant> nearByRestaurants =
                            model.getNearbyRestaurants();

                        return GridCard(
                          img: nearByRestaurants[index].thumbnailUrl,
                          name: nearByRestaurants[index].name,
                          restaurantId: nearByRestaurants[index].id,
                          favTap: () => model.addToFavourites(
                            nearByRestaurants[index].id,
                          ),
                          isFav: model.favouriteRestaurants.contains(
                            nearByRestaurants[index].id,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
        ),
      ),
    );
  }
}
