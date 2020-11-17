import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/viewmodels/customer/tas_map_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TasMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<TasMapViewModel>.withConsumer(
      viewModel: TasMapViewModel(),
      onModelReady: (model) => model.getViewData(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: model.cameraPosition == null || model.restaurants == null
            ? BusyOverlay()
            : Stack(
                children: <Widget>[
                  GoogleMap(
                    mapType: MapType.normal,
                    compassEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: model.cameraPosition,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: model.restaurants
                        .map(
                          (restaurant) => Marker(
                            markerId: MarkerId(restaurant.id + '-marker'),
                            position: LatLng(
                                restaurant.latitude, restaurant.longitude),
                            infoWindow: InfoWindow(
                              title: restaurant.name,
                            ),
                            icon: model.customIcon,
                            onTap: () => model.showRestaurantModalBottomSheet(
                              restaurant,
                              context,
                            ),
                          ),
                        )
                        .toSet(),
                    onMapCreated: (GoogleMapController controller) {
                      model.controller.complete(controller);
                      controller.setMapStyle(model.mapStyle);
                    },
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(
                                    0,
                                    3,
                                  ),
                                ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  splashColor: Colors.grey,
                                  icon: Icon(Icons.keyboard_arrow_left),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Expanded(
                                  child: TextField(
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.go,
                                    controller: model.searchController,
                                    onChanged: (queryString) =>
                                        model.getSearchResults(
                                      queryString,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      hintText: FlutterI18n.translate(
                                        context,
                                        'search_places',
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  splashColor: Colors.grey,
                                  icon: Icon(Icons.search),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.searchController.text.isEmpty
                                ? 0
                                : model.searchResults.length > 4
                                    ? 4
                                    : model.searchResults.length,
                            itemBuilder: (context, index) {
                              Restaurant currentRestaurant =
                                  model.searchResults[index];
                              return ListTile(
                                title: Text(currentRestaurant.name),
                                subtitle: Text(currentRestaurant.address),
                                tileColor: Colors.white,
                                onTap: () {
                                  model.zoomToSelectedRestaurant(
                                    currentRestaurant,
                                    context,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
