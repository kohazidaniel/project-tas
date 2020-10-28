import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/models/tas_user.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  TasUser _currentUser;
  TasUser get currentUser => _currentUser;

  Restaurant _userRestaurant;
  Restaurant get userRestaurant => _userRestaurant;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return user != null;
    } catch (error) {
      return error;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String userRole,
  }) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = TasUser(
        id: result.user.uid,
        email: email,
        fullName: fullName,
        userRole: userRole,
      );

      await _firestoreService.createUser(_currentUser);

      return result.user != null;
    } catch (error) {
      return error;
    }
  }

  // Kijelentkezik, majd a bejelentkezési felületre navigál
  Future signOut() async {
    _firebaseAuth
        .signOut()
        .then((_) => _navigationService.navigateToLoginPage());
  }

  // Lekéri hogy be van e jelenetkezve a felhasználó, ha igen akkor az adatait is lekéri
  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
      if (_currentUser.userRole == 'RESTAURANT') {
        _userRestaurant =
            await _firestoreService.getUserRestaurant(_currentUser.id);
      }
    }
  }
}
