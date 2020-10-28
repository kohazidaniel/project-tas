import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/views/restaurant/menu_item_details_view.dart';
import 'package:tas/viewmodels/restaurant/restaurant_menu_view_model.dart';

class RestaurantMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RestaurantMenuViewModel>.withConsumer(
      viewModel: RestaurantMenuViewModel(),
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
          body: FutureBuilder<dynamic>(
            future: model.getMenuItems(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                if (true) {
                  children = <Widget>[
                    Container(
                      alignment: Alignment.center,
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
                    ),
                  ];
                } else {
                  children = <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Result: ${snapshot.data}'),
                    )
                  ];
                }
              } else {
                children = <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              );
            },
          )),
    );
  }
}
