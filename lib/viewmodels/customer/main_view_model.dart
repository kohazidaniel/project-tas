import 'package:flutter/widgets.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class MainViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authService = locator<AuthService>();
  final PageController _pageController = PageController();

  PageController get pageController => _pageController;

  int _page = 0;
  int get page => _page;

  void onPageChanged(int page) {
    this._page = page;
    notifyListeners();
  }

  Stream<int> listenToUnSeenReservationListLength() {
    return _firestoreService
        .listenToUnSeenReservationListLength(_authService.currentUser.id);
  }
}
