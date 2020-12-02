import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:tas/ui/shared/app_colors.dart';
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

  int _totalSteps = 5;
  int get totalSteps => _totalSteps;

  List<String> _selectedTypes = [];
  List<String> get selectedTypes => _selectedTypes;

  File _imageFile;
  File get imageFile => _imageFile;

  TimeOfDay _openingTime;
  TimeOfDay get openingTime => _openingTime;

  TimeOfDay _closingTime;
  TimeOfDay get closingTime => _closingTime;

  Position currentPosition;

  String restaurantNameErrorMessage = "";
  String restaurantDescriptionErrorMessage = "";
  String restaurantTypeErrorMessage = "";
  String restaurantImageErrorMessage = "";
  String restaurantAddressErrorMessage = "";
  String openingHoursErrorMessage = "";

  FocusNode nameNode = FocusNode();
  FocusNode descriptionNode = FocusNode();
  FocusNode addressNode = FocusNode();

  ImagePicker picker = ImagePicker();

  void createRestaurant(
    String restaurantName,
    String restaurantDescription,
    BuildContext context,
  ) async {
    resetMessages();
    setBusy(true);

    int validationErrorOnStep;

    if (_closingTime == null || _openingTime == null) {
      validationErrorOnStep = 5;
      openingHoursErrorMessage = "Kérlek add meg a nyitvatartást";
    }

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
          address: addressController.text,
          openingTime: _openingTime.format(context),
          closingTime: _closingTime.format(context),
          ratings: [],
          fcmToken: _authenticationService.currentUser.fcmToken,
        ),
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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

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

  Future<void> selectTime(
      {BuildContext context, bool isClosingTime = false}) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: isClosingTime
          ? _closingTime ?? TimeOfDay.now()
          : _openingTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      if (isClosingTime) {
        _closingTime = picked;
      } else {
        _openingTime = picked;
      }
    }
    notifyListeners();
  }

  void resetMessages() {
    restaurantNameErrorMessage = "";
    restaurantDescriptionErrorMessage = "";
    restaurantTypeErrorMessage = "";
    restaurantImageErrorMessage = "";
    restaurantAddressErrorMessage = "";
    openingHoursErrorMessage = "";
  }
}
