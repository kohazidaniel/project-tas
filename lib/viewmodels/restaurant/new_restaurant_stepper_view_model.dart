import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/cloud_storage_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:uuid/uuid.dart';

class NewRestaurantStepperViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  final addressController = TextEditingController();

  int _currStep = 0;
  int get currStep => _currStep;

  int _totalSteps = 4;
  int get totalSteps => _totalSteps;

  List<String> _selectedTypes = [];
  List<String> get selectedTypes => _selectedTypes;

  File _imageFile;
  File get imageFile => _imageFile;

  Position currentPosition;

  String restaurantNameErrorMessage = "";
  String restaurantDescriptionErrorMessage = "";
  String restaurantTypeErrorMessage = "";
  String restaurantImageErrorMessage = "";
  String restaurantAddressErrorMessage = "";

  ImagePicker picker = ImagePicker();

  void createRestaurant(
    String restaurantName,
    String restaurantDescription,
  ) async {
    resetMessages();
    setBusy(true);

    int validationErrorOnStep;

    if (addressController.text.isEmpty) {
      validationErrorOnStep = 4;
      restaurantAddressErrorMessage = "Kérlek add meg a hely címét";
    }

    if (currentPosition == null) {
      try {
        List<Location> locations = await locationFromAddress(
          addressController.text,
        );
        currentPosition = Position(
          latitude: locations[0].latitude,
          longitude: locations[0].longitude,
        );
      } catch (e) {
        validationErrorOnStep = 4;
        restaurantAddressErrorMessage = "Helytelen cím";
      }
    }

    if (_imageFile == null) {
      validationErrorOnStep = 3;
      restaurantImageErrorMessage = "Kérlek válassz ki egy képet";
    }

    if (_selectedTypes.isEmpty) {
      validationErrorOnStep = 2;
      restaurantTypeErrorMessage = "Legalább 1 típust válassz ki";
    }

    if (restaurantDescription.isEmpty) {
      validationErrorOnStep = 1;
      restaurantDescriptionErrorMessage = "Adj meg egy menő leírást";
    }

    if (restaurantName.isEmpty) {
      validationErrorOnStep = 0;
      restaurantNameErrorMessage = "Add meg a hely nevét";
    }

    if (validationErrorOnStep != null) {
      _currStep = validationErrorOnStep;
      notifyListeners();
      setBusy(false);
    } else {
      String restaurantId = Uuid().v4();
      CloudStorageResult result = await _cloudStorageService.uploadImage(
        imageToUpload: _imageFile,
        title: '$restaurantName-thumbnail',
        path: 'restaurants/thumbnails/',
      );

      await _firestoreService.createRestaurant(
        new Restaurant(
            ownerId: _authenticationService.currentUser.id,
            id: restaurantId,
            name: restaurantName,
            description: restaurantDescription,
            restaurantTypes: _selectedTypes,
            thumbnailUrl: result.imageUrl,
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude,
            address: addressController.text),
      );

      _authenticationService.isUserLoggedIn();

      setBusy(false);

      _navigationService.navigateTo(RestaurantMainViewRoute);
    }
  }

  Future getCurrentPosition() async {
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      currentPosition.latitude,
      currentPosition.longitude,
    );

    addressController.text =
        '${placemarks[0].postalCode} ${placemarks[0].locality}, ${placemarks[0].thoroughfare} ${placemarks[0].subThoroughfare}';

    notifyListeners();
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    _imageFile = File(pickedFile.path);
    notifyListeners();
  }

  void addToSelectedTypes(String typeSlug) {
    if (_selectedTypes.contains(typeSlug)) {
      _selectedTypes.remove(typeSlug);
    } else {
      _selectedTypes.add(typeSlug);
    }
    notifyListeners();
  }

  void onStepContinue() {
    if (_currStep < _totalSteps) {
      _currStep += 1;
    } else {
      _currStep = 0;
    }
    notifyListeners();
  }

  // ignore: missing_return
  Future<bool> onStepCancel() {
    if (_currStep > 0) _currStep -= 1;
    notifyListeners();
  }

  void onStepTapped(step) {
    _currStep = step;
    notifyListeners();
  }

  void resetMessages() {
    restaurantNameErrorMessage = "";
    restaurantDescriptionErrorMessage = "";
    restaurantTypeErrorMessage = "";
    restaurantImageErrorMessage = "";
    restaurantAddressErrorMessage = "";
  }
}
