import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tas/constants/route_names.dart';
import 'package:tas/locator.dart';
import 'package:tas/services/navigation_service.dart';
import 'package:tas/ui/widgets/star_rating.dart';

class SliderItem extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  final String name;
  final String img;
  final String restaurantId;
  final bool isFav;
  final double rating;
  final Function favTap;
  final int raters;

  SliderItem({
    Key key,
    @required this.name,
    @required this.img,
    @required this.restaurantId,
    @required this.isFav,
    @required this.favTap,
    this.rating,
    this.raters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.2,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: -10.0,
                bottom: 3.0,
                child: RawMaterialButton(
                  onPressed: favTap,
                  fillColor: Colors.white,
                  shape: CircleBorder(),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 2.0, top: 8.0),
            child: Text(
              "$name",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 2,
            ),
          ),
          raters == null
              ? Text(
                  'Nincs értékelés',
                  style: TextStyle(
                    fontSize: 11.0,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                  child: Row(
                    children: <Widget>[
                      SmoothStarRating(
                        starCount: 5,
                        color: Colors.yellow,
                        allowHalfRating: true,
                        rating: rating,
                        size: 10.0,
                      ),
                      Text(
                        "$rating ($raters ${FlutterI18n.translate(context, "review")})",
                        style: TextStyle(
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      onTap: () {
        _navigationService.navigateTo(
          PlaceDetailsViewRoute,
          arguments: restaurantId,
        );
      },
    );
  }
}
