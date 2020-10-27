import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:tas/viewmodels/restaurant/restaurant_main_view_model.dart';

class RestaurantMenuViewModel extends RestaurantMainViewModel {
  File _imageFile;
  File get imageFile => _imageFile;

  ImagePicker picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    _imageFile = File(pickedFile.path);
    notifyListeners();
  }
}
