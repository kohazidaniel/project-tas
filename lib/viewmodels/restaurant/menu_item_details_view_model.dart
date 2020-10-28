import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/cloud_storage_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:uuid/uuid.dart';

class MenuItemDetailsViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  File _imageFile;
  File get imageFile => _imageFile;

  String _selectedType;
  String get selectedType => _selectedType;

  ImagePicker picker = ImagePicker();

  String nameErrorMessage = "";
  String descriptionErrorMessage = "";
  String priceErrorMessage = "";
  String typeErrorMessage = "";

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    _imageFile = File(pickedFile.path);
    notifyListeners();
  }

  void addMenuItem(String name, String description, String price) async {
    bool isValidationError = false;

    _resetMessage();
    setBusy(true);

    if (name.isEmpty) {
      nameErrorMessage = "Add meg az ital nevét";
      isValidationError = true;
    }
    if (description.isEmpty) {
      descriptionErrorMessage = "Add meg az ital leírását";
      isValidationError = true;
    }
    if (price.isEmpty) {
      priceErrorMessage = "Add meg az ital árát";
      isValidationError = true;
    }
    if (_selectedType == null) {
      typeErrorMessage = "Add meg az ital kategóriáját";
      isValidationError = true;
    }

    if (isValidationError) {
      notifyListeners();
      setBusy(false);
    } else {
      String menuItemId = Uuid().v4();
      CloudStorageResult result = await _cloudStorageService.uploadImage(
        imageToUpload: _imageFile,
        title: '$name-thumbnail',
        path: 'restaurants/menuitems/',
      );

      _firestoreService.createMenuItem(MenuItem(
        id: menuItemId,
        name: name,
        description: description,
        price: int.parse(price),
        menuItemType: _selectedType,
        photoUrl: result.imageUrl,
        restaurantId: _authenticationService.userRestaurant.id,
      ));

      setBusy(false);

      _navigationService.pop();
    }
  }

  void setSelectedType(String type) {
    _selectedType = type;
  }

  void _resetMessage() {
    nameErrorMessage = "";
    descriptionErrorMessage = "";
    priceErrorMessage = "";
    typeErrorMessage = "";
  }
}
