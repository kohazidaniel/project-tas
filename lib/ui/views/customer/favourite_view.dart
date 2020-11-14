import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/grid_card.dart';
import 'package:tas/viewmodels/customer/favourite_view_model.dart';

class FavouriteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<FavouriteViewModel>.withConsumer(
      viewModel: FavouriteViewModel(),
      onModelReady: (model) => model.getViewData(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: model.favouriteRestaurants == null || model.restaurants == null
              ? Container()
              : model.restaurants.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            size: 64.0,
                            color: Colors.grey[400],
                          ),
                          Text(
                            'Keresd meg a kedvenc helyeidet',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    )
                  : ListView(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Text(
                          FlutterI18n.translate(context, "favourite_places"),
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.25),
                          ),
                          itemCount: model.restaurants.length,
                          itemBuilder: (BuildContext context, int index) {
                            Restaurant currentRestaurant =
                                model.restaurants[index];
                            return GridCard(
                              img: currentRestaurant.thumbnailUrl,
                              restaurantId: currentRestaurant.id,
                              isFav: true,
                              name: currentRestaurant.name,
                              favTap: () => model.removeFromFavourites(
                                currentRestaurant.id,
                              ),
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
