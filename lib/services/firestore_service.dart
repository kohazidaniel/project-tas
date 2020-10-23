import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/models/tas_user.dart';

class FirestoreService {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _restaurants =
      FirebaseFirestore.instance.collection('restaurants');

  Future createUser(TasUser user) async {
    try {
      await _users.doc(user.id).set(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _users.doc(uid).get();
      return TasUser.fromData(userData.data());
    } catch (e) {
      return e.message;
    }
  }

  Future createRestaurant(Restaurant restaurant) async {
    try {
      await _restaurants.doc(restaurant.id).set(restaurant.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future isNewRestaurant(TasUser user) async {
    try {
      await _restaurants.where('ownerId', isEqualTo: user.id).get();
    } catch (e) {
      return e.message;
    }
  }
}
