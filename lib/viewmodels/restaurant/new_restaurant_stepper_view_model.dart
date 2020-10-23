import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';

import 'package:tas/viewmodels/base_model.dart';
import 'package:uuid/uuid.dart';

class NewRestaurantStepperViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  int _currStep = 0;
  int get currStep => _currStep;

  int _totalSteps = 3;
  int get totalSteps => _totalSteps;

  List<String> _selectedTypes = [];
  List<String> get selectedTypes => _selectedTypes;

  File _imageFile;
  File get imageFile => _imageFile;

  String restaurantNameErrorMessage = "";
  String restaurantDescriptionErrorMessage = "";
  String restaurantTypeErrorMessage = "";
  String restaurantImageErrorMessage = "";

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

    String uploadedFileName = await uploadImageToFirebase();
    String restaurantId = Uuid().v4();

    await _firestoreService.createRestaurant(
      new Restaurant(
        ownerId: _authenticationService.currentUser.id,
        id: restaurantId,
        name: restaurantName,
        description: restaurantDescription,
        restaurantTypes: _selectedTypes,
        thumbnail: uploadedFileName,
      ),
    );

    setBusy(false);
  }

  Future<String> uploadImageToFirebase() async {
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('restaurants/thumbnails/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    return taskSnapshot.ref.getName();
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
  }
}
