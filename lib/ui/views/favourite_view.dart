import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/grid_card.dart';
import 'package:tas/viewmodels/favourite_view_model.dart';

final List<String> imgList = [
  "https://etterem.hu/img/max960/p1343n/1362941577-3763.jpg",
  "https://drinkunion.hu/attachment/0001/861_copy_3_telthaz.jpg",
  "https://etterem.hu/img/x/p406n/1353704056-2962.jpg"
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
