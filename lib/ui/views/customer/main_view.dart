import 'package:animations/animations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/views/customer/cart_view.dart';
import 'package:tas/ui/views/customer/favourite_view.dart';
import 'package:tas/ui/views/customer/home_view.dart';
import 'package:tas/ui/views/customer/tas_map_view.dart';
import 'package:tas/ui/views/notification_view.dart';
import 'package:tas/ui/views/profile_view.dart';
import 'package:tas/ui/widgets/badge.dart';
import 'package:tas/viewmodels/customer/main_view_model.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: ViewModelProvider<MainViewModel>.withConsumer(
        viewModel: MainViewModel(),
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 35,
                  width: 35,
                  child: FlareActor(
                    "assets/flare/beer_drink.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "normal",
                  ),
                ),
                Text(
                  'TAS',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ],
            ),
            backgroundColor: backgroundColor,
            elevation: 0.0,
            actions: <Widget>[
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                openBuilder: (BuildContext context, VoidCallback _) {
                  return NotificationView();
                },
                closedElevation: 0.0,
                closedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50 / 2),
                  ),
                ),
                openColor: primaryColor,
                closedBuilder:
                    (BuildContext context, VoidCallback openContainer) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: IconBadge(
                      icon: Icons.notifications,
                      size: 22.0,
                      badgeValue: 0,
                      color: primaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: model.pageController,
            onPageChanged: model.onPageChanged,
            children: <Widget>[
              HomeView(),
              FavouriteView(),
              CartView(),
              ProfileView()
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 7),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    size: 24.0,
                  ),
                  color: model.page == 0
                      ? primaryColor
                      : primaryColor.withOpacity(0.5),
                  onPressed: () => model.pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    size: 24.0,
                  ),
                  color: model.page == 1
                      ? primaryColor
                      : primaryColor.withOpacity(0.5),
                  onPressed: () => model.pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 0,
                    color: backgroundColor,
                  ),
                  onPressed: () => {},
                ),
                IconButton(
                  icon: IconBadge(
                    icon: Icons.event_seat,
                    size: 24.0,
                    badgeValue: 0,
                  ),
                  color: model.page == 2
                      ? primaryColor
                      : primaryColor.withOpacity(0.5),
                  onPressed: () => model.pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut),
                ),
                IconButton(
                  icon: Icon(
                    Icons.person,
                    size: 24.0,
                  ),
                  color: model.page == 3
                      ? primaryColor
                      : primaryColor.withOpacity(0.5),
                  onPressed: () => model.pageController.animateToPage(3,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut),
                ),
                SizedBox(width: 7),
              ],
            ),
            color: backgroundColor,
            shape: CircularNotchedRectangle(),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            openBuilder: (BuildContext context, VoidCallback _) {
              return TasMapView();
            },
            closedElevation: 0.0,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50 / 2),
              ),
            ),
            openColor: primaryColor,
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return FloatingActionButton(
                backgroundColor: primaryColor,
                elevation: 4.0,
                child: Icon(
                  Icons.search,
                  color: backgroundColor,
                ),
              );
            },
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
