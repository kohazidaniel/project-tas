import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/star_rating.dart';

class CartItem extends StatelessWidget {
  final String name;
  final String img;
  final bool isFav;
  final double rating;
  final int raters;
  final int price;
  final String description;
  final bool isCart;
  final int quantity;
  final Function removeFromCartTap;
  final Function addToCartTap;

  CartItem({
    Key key,
    @required this.name,
    @required this.img,
    @required this.isFav,
    this.rating,
    this.raters,
    @required this.price,
    this.description,
    this.isCart = false,
    this.quantity = 0,
    this.removeFromCartTap,
    this.addToCartTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.width / 3,
                width: MediaQuery.of(context).size.width / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "$img",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    "$name",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
                    SmoothStarRating(
                      starCount: 1,
                      color: rating == null ? Colors.grey : Colors.yellow,
                      allowHalfRating: true,
                      rating: 5.0,
                      size: 12.0,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      rating == null
                          ? 'Nincs értékelés'
                          : '5.0 (23 ${FlutterI18n.translate(context, "review")})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "$price Ft",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    horizontalSpaceMedium,
                    isCart
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  splashRadius: 16.0,
                                  onPressed: removeFromCartTap,
                                  icon: Icon(
                                    Icons.remove,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Container(
                                  color: Colors.grey.shade200,
                                  padding: const EdgeInsets.only(
                                    bottom: 2,
                                    right: 12,
                                    left: 12,
                                  ),
                                  child: Text(
                                    "$quantity",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  splashRadius: 16.0,
                                  onPressed: addToCartTap,
                                  icon: Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
