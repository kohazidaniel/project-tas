import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/user.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();

  User _currentUser;
  User get currentUser => _currentUser;

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
  }) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = User(
        id: result.user.uid,
        email: email,
        fullName: fullName,
        userRole: "USER",
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
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }
}
