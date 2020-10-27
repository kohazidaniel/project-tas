import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/category_card.dart';
import 'package:tas/ui/widgets/grid_card.dart';
import 'package:tas/ui/widgets/slider_item.dart';
import 'package:tas/viewmodels/customer/home_view_model.dart';

final List<String> imgList = [
  "https://etterem.hu/img/max960/p1343n/1362941577-3763.jpg",
  "https://drinkunion.hu/attachment/0001/861_copy_3_telthaz.jpg",
  "https://etterem.hu/img/x/p406n/1353704056-2962.jpg"
];

List categories = [
  {"name": "Sörözõ", "icon": FontAwesomeIcons.beer, "items": 5},
  {"name": "Kávézó", "icon": FontAwesomeIcons.coffee, "items": 20},
  {"name": "Bisztró", "icon": FontAwesomeIcons.utensils, "items": 9},
  {"name": "Borozó", "icon": FontAwesomeIcons.wineGlass, "items": 9}
];

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, "recommended_places"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              verticalSpaceTiny,
              CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 2.4,
                  viewportFraction: 1.0,
                  autoPlay: false,
                ),
                items: imgList
                    .map((item) => SliderItem(
                        name: "Y söröző",
                        img: item,
                        isFav: true,
                        rating: 5,
                        raters: 125))
                    .toList(),
              ),
              verticalSpaceSmall,
              Text(
                FlutterI18n.translate(context, "categories"),
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                height: 65.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: categories == null ? 0 : categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map cat = categories[index];
                    return CategoryCard(
                      icon: cat['icon'],
                      title: cat['name'],
                      items: cat['items'].toString(),
                      isHome: true,
                    );
                  },
                ),
              ),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, "places_nearby"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              verticalSpaceTiny,
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
                    isFav: false,
                    name: "Kocsma",
                    rating: 5.0,
                    raters: 23,
                  );
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
