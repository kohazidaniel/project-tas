import 'package:flutter/material.dart';
import 'package:tas/ui/views/login_view.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  // Kivesz a veremből egy útvonalat
  void pop() {
    return _navigationKey.currentState.pop();
  }

  // Beletesz a verembe egy útvonalat
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  // A bejelentkezési felületre navigál, és kiveszi az összes korábbi útvonalat a veremből
  Future<dynamic> navigateToLoginPage() {
    return _navigationKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginView()),
        (Route<dynamic> route) => false);
  }
}
