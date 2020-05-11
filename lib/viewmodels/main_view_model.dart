import 'package:flutter/widgets.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/viewmodels/base_model.dart';

class MainViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final PageController _pageController = PageController();
  int _page = 0;

  NavigationService get navigationService => _navigationService;
  PageController get pageController => _pageController;
  int get page => _page;

  void onPageChanged(int page) {
    this._page = page;
    notifyListeners();
  }
}
