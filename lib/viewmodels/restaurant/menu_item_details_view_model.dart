import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/cloud_storage_service.dart';
import 'package:tas/services/dialog_service.dart';
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
  final DialogService _dialogService = locator<DialogService>();

  MenuItem selectedMenuItem;

  File _imageFile;
  File get imageFile => _imageFile;

  String _selectedType;
  String get selectedType => _selectedType;

  MenuItemDetailsViewModel({this.selectedMenuItem}) {
    this._selectedType = selectedMenuItem?.menuItemType;
  }

  ImagePicker picker = ImagePicker();

  FocusNode descriptionNode = FocusNode();
  FocusNode priceNode = FocusNode();

  String imageErrorMessage = "";
  String nameErrorMessage = "";
  String descriptionErrorMessage = "";
  String priceErrorMessage = "";
  String typeErrorMessage = "";

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    _imageFile = File(pickedFile.path);
    notifyListeners();
  }

  Future<bool> deleteMenuItem() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Törlés',
      description:
          'Biztos szeretnéd törölni a(z) ${selectedMenuItem.name} nevű tételt?',
      confirmationTitle: 'Igen',
      cancelTitle: 'Nem',
    );

    if (dialogResponse.confirmed) {
      setBusy(true);
      await _firestoreService.deleteMenuItem(selectedMenuItem.id);
      setBusy(false);

      return true;
    }

    return false;
  }

  void addMenuItem({
    String name,
    String description,
    String price,
    bool isUpdating = false,
  }) async {
    bool isValidationError = false;

    _resetMessage();
    setBusy(true);

    if (_imageFile == null && !isUpdating) {
      imageErrorMessage = "Tölts föl egy képet";
      isValidationError = true;
    }
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
    if (int.tryParse(price) == null) {
      priceErrorMessage = "Helytelen formátum";
      isValidationError = true;
    }

    if (isValidationError) {
      notifyListeners();
      setBusy(false);
    } else {
      String menuItemId = Uuid().v4();
      CloudStorageResult result;

      if (_imageFile != null) {
        result = await _cloudStorageService.uploadImage(
          imageToUpload: _imageFile,
          title: '$name-thumbnail',
          path: 'restaurants/menuitems/',
        );
      }

      if (isUpdating) {
        _firestoreService.updateMenuItem(
          MenuItem(
            id: selectedMenuItem.id,
            name: name,
            description: description,
            price: int.parse(price),
            menuItemType: _selectedType,
            photoUrl:
                result != null ? result.imageUrl : selectedMenuItem.photoUrl,
            restaurantId: selectedMenuItem.restaurantId,
          ),
        );
      } else {
        _firestoreService.createMenuItem(
          MenuItem(
            id: menuItemId,
            name: name,
            description: description,
            price: int.parse(price),
            menuItemType: _selectedType,
            photoUrl: result.imageUrl,
            restaurantId: _authenticationService.userRestaurant.id,
          ),
        );
      }

      setBusy(false);

      _navigationService.pop();
    }
  }

  void setSelectedType(String type) {
    _selectedType = type;
  }

  void _resetMessage() {
    imageErrorMessage = "";
    nameErrorMessage = "";
    descriptionErrorMessage = "";
    priceErrorMessage = "";
    typeErrorMessage = "";
  }
}
