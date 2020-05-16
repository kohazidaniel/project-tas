import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/grid_card.dart';
import 'package:tas/viewmodels/favourite_view_model.dart';

final List<String> imgList = [
  "https://etterem.hu/img/max960/p1343n/1362941577-3763.jpg",
  "https://scontent-frt3-1.xx.fbcdn.net/v/t1.0-9/50822266_609808429469138_4704702644847902720_o.jpg?_nc_cat=107&_nc_sid=e3f864&_nc_ohc=oZovCR1K5JUAX8NW1dC&_nc_ht=scontent-frt3-1.xx&oh=3d5c108b8adf8fa2848952b0c9ced361&oe=5EE005F3",
  "https://scontent-frt3-1.xx.fbcdn.net/v/t1.0-9/31120_122420111114653_4554442_n.jpg?_nc_cat=102&_nc_sid=09cbfe&_nc_ohc=NL_RN1qT2O4AX87N_7S&_nc_ht=scontent-frt3-1.xx&oh=b5aa96fc4f14f9a502b3bebd161916be&oe=5EE03FF3"
];

class FavouriteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<FavouriteViewModel>.withConsumer(
        viewModel: FavouriteViewModel(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundColor,
            body: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(
                    FlutterI18n.translate(context, "favourite_places"),
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.25),
                    ),
                    itemCount: imgList == null ? 0 : imgList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GridCard(
                        img: imgList[index],
                        isFav: true,
                        name: "Kocsma",
                        rating: 5.0,
                        raters: 23,
                      );
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            )));
  }
}
