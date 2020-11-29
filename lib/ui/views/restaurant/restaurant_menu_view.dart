import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/views/restaurant/menu_item_details_view.dart';
import 'package:tas/ui/widgets/animated_button.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/ui/widgets/cart_item.dart';
import 'package:tas/viewmodels/restaurant/restaurant_menu_view_model.dart';
import 'package:grouped_list/grouped_list.dart';

class RestaurantMenuView extends StatelessWidget {
  final String restaurantId;
  final String reservationId;
  RestaurantMenuView({this.restaurantId, this.reservationId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantMenuViewModel>.reactive(
      viewModelBuilder: () => RestaurantMenuViewModel(
        restaurantId: restaurantId,
      ),
      onModelReady: (model) {
        model.listenToPosts();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            FlutterI18n.translate(context, 'drink_menu'),
            style: TextStyle(color: primaryColor),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: StreamBuilder<List<MenuItem>>(
              stream: model.listenToPosts(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<MenuItem>> snapshot,
              ) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  Map<String, int> scrollOffSetByMenuTypes = Map();
                  String lastMenuType;

                  for (int i = 0; i < snapshot.data.length; i++) {
                    if (i == 0) {
                      lastMenuType = snapshot.data[i].menuItemType;
                      scrollOffSetByMenuTypes[lastMenuType] = 0;
                    }
                    if (lastMenuType != snapshot.data[i].menuItemType) {
                      lastMenuType = snapshot.data[i].menuItemType;
                      scrollOffSetByMenuTypes[lastMenuType] = i;
                    }
                  }

                  List<Widget> tabs = scrollOffSetByMenuTypes.entries
                      .map(
                        (entry) => Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              FlutterI18n.translate(
                                context,
                                'menuItemTypes.' + entry.key,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DefaultTabController(
                        length: scrollOffSetByMenuTypes.keys.length,
                        child: Builder(builder: (BuildContext context) {
                          model.scrollController.addListener(
                            () {
                              int index;
                              for (int i = 0;
                                  i < scrollOffSetByMenuTypes.length;
                                  i++) {
                                if (model.scrollController.position.pixels >=
                                    scrollOffSetByMenuTypes.values
                                                .elementAt(i) *
                                            167 +
                                        i * 44) {
                                  index = i;
                                }
                              }
                              DefaultTabController.of(context).animateTo(index);
                            },
                          );

                          return TabBar(
                            onTap: (value) {
                              List<int> scrollPoints =
                                  scrollOffSetByMenuTypes.values.toList();
                              model.setMenuItemType(value, scrollPoints[value]);
                            },
                            isScrollable: true,
                            indicatorColor: Colors.black,
                            labelColor: Colors.black,
                            tabs: tabs,
                          );
                        }),
                      )
                    ],
                  );
                }
                return Container(
                  height: 50.0,
                  color: Colors.grey[50],
                );
              },
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            restaurantId != null
                ? Container()
                : OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    openBuilder: (BuildContext context, VoidCallback _) {
                      return MenuItemDetailsView();
                    },
                    closedElevation: 0.0,
                    closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100 / 2),
                      ),
                    ),
                    openColor: primaryColor,
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.add_box_outlined,
                          color: primaryColor,
                        ),
                      );
                    },
                  ),
          ],
        ),
        body: StreamBuilder<List<MenuItem>>(
          stream: model.listenToPosts(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<MenuItem>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return BusyOverlay();
            } else {
              if (snapshot.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: 64.0,
                        color: Colors.grey[400],
                      ),
                      Text(
                        'Üres az itallap',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return GroupedListView<MenuItem, String>(
                  controller: model.scrollController,
                  elements: snapshot.data,
                  groupBy: (element) => element.menuItemType,
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: Text(
                      FlutterI18n.translate(
                        context,
                        'menuItemTypes.' + groupByValue,
                      ),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  itemBuilder: (context, MenuItem item) => OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    tappable: restaurantId == null,
                    openBuilder: (BuildContext context, VoidCallback _) {
                      return MenuItemDetailsView(
                        selectedCartItem: item,
                        isUpdating: true,
                      );
                    },
                    closedElevation: 0.0,
                    openColor: primaryColor,
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return CartItem(
                        img: item.photoUrl,
                        isFav: false,
                        name: item.name,
                        price: item.price,
                        description: item.description,
                        isCart: reservationId != null,
                        quantity: model.getQuantity(item.id),
                        removeFromCartTap: () => model.removeFromCart(item),
                        addToCartTap: () => model.addToCart(item),
                      );
                    },
                  ),
                  itemComparator: (item1, item2) =>
                      item1.menuItemType.compareTo(item2.menuItemType),
                  order: GroupedListOrder.ASC,
                );
              }
            }
          },
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          height: model.cartMenuItemIds.length > 0 ? 55.0 : 0.0,
          child: BottomAppBar(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Összesen: ',
                      ),
                      TextSpan(
                        text: '${model.total} Ft',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedButton(
                  onTap: () => model.orderMenuItems(reservationId),
                  animationDuration: const Duration(milliseconds: 1000),
                  initialText: "RENDELÉS",
                  finalText: "MEGRENDELVE",
                  iconData: Icons.check,
                  iconSize: 20.0,
                  buttonStyle: AnimatedButtonStyle(
                    primaryColor: primaryColor,
                    secondaryColor: Colors.white,
                    elevation: 10.0,
                    initialTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    finalTextStyle: TextStyle(
                      color: primaryColor,
                    ),
                    borderRadius: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
