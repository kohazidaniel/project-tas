import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/viewmodels/restaurant/restaurant_order_list_view_model.dart';

class RestaurantOrderListView extends StatelessWidget {
  final String restaurantId;
  RestaurantOrderListView({this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantOrderListViewModel>.reactive(
      viewModelBuilder: () => RestaurantOrderListViewModel(
        restaurantId: restaurantId,
      ),
      builder: (context, model, child) => Scaffold(),
    );
  }
}
