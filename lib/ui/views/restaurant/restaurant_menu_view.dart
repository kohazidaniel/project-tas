import 'package:animations/animations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/views/restaurant/menu_item_details_view.dart';
import 'package:tas/ui/widgets/cart_item.dart';
import 'package:tas/ui/widgets/chip_list.dart';
import 'package:tas/viewmodels/restaurant/restaurant_menu_view_model.dart';
import 'package:grouped_list/grouped_list.dart';

class RestaurantMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RestaurantMenuViewModel>.withConsumer(
      viewModel: RestaurantMenuViewModel(),
      onModelReady: (model) => model.listenToPosts(),
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
            'Itallap',
            style: TextStyle(color: primaryColor),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: ChipList(
              menuTypes: model.menuItemTypes,
              selectedMenuType: model.selectedMenuItemType,
              onPress: model.setMenuItemType,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            OpenContainer(
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 75,
                      width: 75,
                      child: FlareActor(
                        "assets/flare/beer_drink.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "normal",
                      ),
                    ),
                  ],
                ),
              );
            } else {
              if (snapshot.data == null) {
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
                    padding: EdgeInsets.only(left: 15.0),
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
                  itemBuilder: (context, MenuItem item) => CartItem(
                    img: item.photoUrl,
                    isFav: false,
                    name: item.name,
                    price: item.price,
                    description: item.description,
                  ),
                  itemComparator: (item1, item2) =>
                      item1.menuItemType.compareTo(item2.menuItemType),
                  order: GroupedListOrder.ASC,
                );
              }
            }
          },
        ),
      ),
    );
  }
}
