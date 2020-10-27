import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:uuid/uuid.dart';

class NewRestaurantStepperViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

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

    if (restaurantName.isEmpty) {
      _currStep = 0;
      restaurantNameErrorMessage = "Add meg a hely nevét";
      notifyListeners();
      setBusy(false);
      return;
    }

    if (restaurantDescription.isEmpty) {
      _currStep = 1;
      restaurantDescriptionErrorMessage = "Adj meg egy menő leírást";
      notifyListeners();
      setBusy(false);
      return;
    }

    if (_selectedTypes.isEmpty) {
      _currStep = 2;
      restaurantTypeErrorMessage = "Legalább 1 típust válassz ki";
      notifyListeners();
      setBusy(false);
      return;
    }

    if (_imageFile == null) {
      _currStep = 3;
      restaurantImageErrorMessage = "Kérlek válassz ki egy képet";
      notifyListeners();
      setBusy(false);
      return;
    }

    if (addressController.text.isEmpty) {
      restaurantAddressErrorMessage = "Kérlek add meg a hely címét";
      notifyListeners();
      setBusy(false);
      return;
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
        restaurantAddressErrorMessage = "Helytelen cím";
        notifyListeners();
        setBusy(false);
        return;
      }
    }

    String thumbnailUrl = await uploadImageToFirebase();
    String restaurantId = Uuid().v4();

    await _firestoreService.createRestaurant(
      new Restaurant(
          ownerId: _authenticationService.currentUser.id,
          id: restaurantId,
          name: restaurantName,
          description: restaurantDescription,
          restaurantTypes: _selectedTypes,
          thumbnailUrl: thumbnailUrl,
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude,
          address: addressController.text),
    );

    setBusy(false);

    _navigationService.navigateTo(RestaurantMainViewRoute);
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

  FutureOr<dynamic> uploadImageToFirebase() async {
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('restaurants/thumbnails/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    return taskSnapshot.ref.getDownloadURL();
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
