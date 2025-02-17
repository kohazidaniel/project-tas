import 'package:tas/ui/views/customer/active_reservation_view.dart';
import 'package:tas/ui/views/customer/book_table_view.dart';
import 'package:tas/ui/views/customer/list_by_categories_view.dart';
import 'package:tas/ui/views/customer/main_view.dart';
import 'package:flutter/material.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/ui/views/customer/reservation_view.dart';
import 'package:tas/ui/views/login_view.dart';
import 'package:tas/ui/views/notification_view.dart';
import 'package:tas/ui/views/customer/place_details_view.dart';
import 'package:tas/ui/views/restaurant/new_restaurant_stepper_view.dart';
import 'package:tas/ui/views/restaurant/restaurant_main_view.dart';
import 'package:tas/ui/views/restaurant/restaurant_reservation_view.dart';
import 'package:tas/ui/views/signup_view.dart';
import 'package:tas/ui/views/startup_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case MainViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MainView(),
      );
    case NotificationViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: NotificationView(),
      );
    case PlaceDetailsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: PlaceDetailsView(
          restaurantId: settings.arguments,
        ),
      );
    case RestaurantMainViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: RestaurantMainView(),
      );
    case StartUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: StartUpView(),
      );
    case NewRestaurantStepperViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: NewRestaurantStepperView(),
      );
    case BookTableViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BookTableView(),
      );
    case ReservationViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ReservationView(
          reservationId: settings.arguments,
        ),
      );
    case ListByCategoriesViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ListByCategoriesView(
          restaurantType: settings.arguments,
        ),
      );
    case ActiveReservationViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ActiveReservationView(
          reservationId: settings.arguments,
        ),
      );
    case RestaurantReservationViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: RestaurantReservationView(
          reservationId: settings.arguments,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return SlideRightRoute(widget: viewToShow);
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Interval(
                    0.00,
                    0.50,
                    curve: Curves.easeInOutQuad,
                  ),
                ),
              ),
              child: child,
            );
          },
        );
}
