import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/category_card.dart';
import 'package:tas/ui/widgets/grid_card.dart';
import 'package:tas/ui/widgets/slider_item.dart';
import 'package:tas/viewmodels/customer/home_view_model.dart';

List categories = [
  {"name": "Sörözõ", "icon": FontAwesomeIcons.beer, "items": 5},
  {"name": "Kávézó", "icon": FontAwesomeIcons.coffee, "items": 20},
  {"name": "Bisztró", "icon": FontAwesomeIcons.utensils, "items": 9},
  {"name": "Borozó", "icon": FontAwesomeIcons.wineGlass, "items": 9}
];

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
          child: ListView(
            children: <Widget>[
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
              model.restaurants == null && model.favouriteRestaurants == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[100],
                      highlightColor: Colors.grey[300],
                      enabled: true,
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                ),
                                height:
                                    MediaQuery.of(context).size.height / 3.2,
                              ),
                              SizedBox(height: 5),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width / 2,
                                height: 18.0,
                                color: Colors.white,
                              ),
                              SizedBox(height: 5),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width / 4,
                                height: 16.0,
                                color: Colors.white,
                              )
                            ],
                          )),
                    )
                  : CarouselSlider(
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
                  itemCount: categories == null ? 0 : categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map cat = categories[index];
                    return CategoryCard(
                      icon: cat['icon'],
                      title: cat['name'],
                      items: cat['items'].toString(),
                      isHome: true,
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
              model.restaurants == null && model.favouriteRestaurants == null
                  ? Container()
                  : GridView.builder(
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
