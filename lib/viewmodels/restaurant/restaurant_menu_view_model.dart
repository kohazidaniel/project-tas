import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class RestaurantMenuViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authenticationService = locator<AuthService>();

  ScrollController scrollController = new ScrollController();

  List<MenuItem> _menuItems;
  List<MenuItem> get menuItems => _menuItems;

  Stream<List<MenuItem>> listenToPosts() {
    Stream<List<MenuItem>> stream =
        _firestoreService.listenToMenuItemssRealTime(
      _authenticationService.userRestaurant.id,
    );

    return stream;
  }

  void setMenuItemType(int index, int scrollPoint) {
    scrollController.animateTo(
      (scrollPoint * 167 + index * 44).toDouble(),
      curve: Curves.ease,
      duration: Duration(milliseconds: 300),
    );
  }
}
