import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/reservation.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/services/auth_service.dart';
import 'package:tas/services/firestore_service.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/viewmodels/base_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class BookTableViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authenticationService = locator<AuthService>();

  final String restaurantId;
  BookTableViewModel({this.restaurantId});

  NavigationService get navigationService => _navigationService;

  int _numberOfPeople = 2;
  int get numberOfPeople => _numberOfPeople;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  TimeOfDay _selectedTime = TimeOfDay.now();
  TimeOfDay get selectedTime => _selectedTime;

  Future<Restaurant> getRestaurant() async {
    return await _firestoreService.getRestaurantById(restaurantId);
  }

  void createReservation() async {
    setBusy(true);
    Timestamp reservationTimeStamp = Timestamp.fromDate(
      _selectedDate.add(
        Duration(hours: _selectedTime.hour, minutes: _selectedTime.minute),
      ),
    );

    String reservationId = Uuid().v4();

    await _firestoreService.createReservation(
      Reservation(
        id: reservationId,
        active: false,
        numberOfPeople: _numberOfPeople,
        restaurantId: reservationId,
        reservationDate: reservationTimeStamp,
        orderMenuItemIds: [],
        total: 0,
        userId: _authenticationService.currentUser.id,
      ),
    );

    setBusy(false);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      locale: Locale('hu'),
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 30),
      ),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) _selectedDate = picked;
    notifyListeners();
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null) _selectedTime = picked;
    notifyListeners();
  }

  void decreaseNumberOfPeople() {
    if (numberOfPeople > 2) {
      _numberOfPeople--;
      notifyListeners();
    }
  }

  void increaseNumberOfPeople() {
    if (numberOfPeople < 10) {
      _numberOfPeople++;
      notifyListeners();
    }
  }

  String getFormattedDate() {
    DateFormat formatter = new DateFormat.yMMMMd('hu');

    return formatter.format(_selectedDate);
  }
}
