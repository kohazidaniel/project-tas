import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/viewmodels/base_model.dart';

class TasMapViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final Completer<GoogleMapController> controller = Completer();
  final searchController = TextEditingController();

  BitmapDescriptor _customIcon;
  BitmapDescriptor get customIcon => _customIcon;

  CameraPosition _cameraPosition;
  CameraPosition get cameraPosition => _cameraPosition;

  List<Restaurant> _restaurants;
  List<Restaurant> get restaurants => _restaurants;

  List<Restaurant> _searchResults = [];
  List<Restaurant> get searchResults => _searchResults;

  String _mapStyle;
  String get mapStyle => _mapStyle;

  void getViewData() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(32, 32)), 'assets/images/marker.png')
        .then((d) {
      _customIcon = d;
    });

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _cameraPosition = CameraPosition(
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
      zoom: 14,
    );

    _restaurants = await _firestoreService.getRestaurants();

    notifyListeners();
  }

  void getSearchResults(String queryString) {
    String lowerCaseQueryString = queryString.toLowerCase();

    _searchResults = _restaurants
        .where(
          (restaurant) =>
              restaurant.name.toLowerCase().contains(lowerCaseQueryString) ||
              restaurant.address.toLowerCase().contains(queryString),
        )
        .toList();

    notifyListeners();
  }

  void zoomToSelectedRestaurant(
      Restaurant selectedRestaurant, BuildContext context) async {
    final GoogleMapController mapController = await controller.future;

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          selectedRestaurant.latitude,
          selectedRestaurant.longitude,
        ),
        zoom: 16,
      )),
    );

    mapController.showMarkerInfoWindow(
      MarkerId(selectedRestaurant.id + '-marker'),
    );

    searchController.text = "";
    FocusScope.of(context).unfocus();

    showRestaurantModalBottomSheet(selectedRestaurant, context);

    notifyListeners();
  }

  void showRestaurantModalBottomSheet(
    Restaurant selectedRestaurant,
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(selectedRestaurant.thumbnailUrl),
              ),
              title: Text(selectedRestaurant.name),
              subtitle: Text(selectedRestaurant.address),
              trailing: FloatingActionButton(
                onPressed: () {
                  _navigationService.pop();
                  _navigationService.navigateTo(
                    PlaceDetailsViewRoute,
                    arguments: selectedRestaurant.id,
                  );
                },
                mini: true,
                backgroundColor: primaryColor,
                child: Icon(
                  Icons.arrow_forward,
                  size: 16.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
