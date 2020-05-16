import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/views/notification_view.dart';
import 'package:tas/ui/widgets/badge.dart';
import 'package:tas/ui/widgets/cart_item.dart';
import 'package:tas/viewmodels/cart_view_model.dart';

List cartItems = [
  {
    "img":
        "https://images.receptmuhely.hu/media/cache/vich_show/images/recipe/63219bc8-c7c0-418e-b100-ee1dd880fa76.jpg",
    "name": "Limonádé",
    "price": 480
  },
  {
    "img":
        "https://secure.ce-tescoassets.com/assets/HU/472/0000054491472/ShotType1_540x540.jpg",
    "name": "Limonádé",
    "price": 480
  }
];

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CartViewModel>.withConsumer(
        viewModel: CartViewModel(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundColor,
            body: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: ListView.builder(
                itemCount: cartItems == null ? 0 : cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  Map item = cartItems[index];
                  return CartItem(
                    img: item['img'],
                    isFav: false,
                    name: item['name'],
                    price: item['price'],
                    rating: 5.0,
                    raters: 23,
                  );
                },
              ),
            ),
            floatingActionButton: OpenContainer(
              transitionType: model.transitionType,
              openBuilder: (BuildContext context, VoidCallback _) {
                return NotificationView();
              },
              closedElevation: 6.0,
              closedColor: primaryColor,
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
                      icon: Icons.arrow_forward,
                      size: 22.0,
                      badgeValue: 0,
                      color: backgroundColor,
                    ));
              },
            )));
  }
}
