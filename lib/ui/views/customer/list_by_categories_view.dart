import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/viewmodels/customer/list_by_categories_view_model.dart';

class ListByCategoriesView extends StatelessWidget {
  final String restaurantType;

  ListByCategoriesView({this.restaurantType});
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ListByCategoriesViewModel>.withConsumer(
      viewModel: ListByCategoriesViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            FlutterI18n.translate(context, 'restaurantTypes.$restaurantType') +
                ' 🍻',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
        ),
        body: FutureBuilder<List<Restaurant>>(
          future: model.getRestaurantsByType(restaurantType),
          builder:
              (BuildContext context, AsyncSnapshot<List<Restaurant>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Restaurant restaurant = snapshot.data[index];

                  return ListTile(
                    title: Text(restaurant.name),
                    subtitle: Text(restaurant.address),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        restaurant.thumbnailUrl,
                      ),
                    ),
                    onTap: () => model.navToRestaurantDetailsView(
                      restaurant.id,
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
