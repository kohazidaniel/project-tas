import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/category_card.dart';
import 'package:tas/ui/widgets/grid_card.dart';
import 'package:tas/ui/widgets/slider_item.dart';
import 'package:tas/viewmodels/home_view_model.dart';

final List<String> imgList = [
  "https://etterem.hu/img/max960/p1343n/1362941577-3763.jpg",
  "https://scontent-frt3-1.xx.fbcdn.net/v/t1.0-9/50822266_609808429469138_4704702644847902720_o.jpg?_nc_cat=107&_nc_sid=e3f864&_nc_ohc=oZovCR1K5JUAX8NW1dC&_nc_ht=scontent-frt3-1.xx&oh=3d5c108b8adf8fa2848952b0c9ced361&oe=5EE005F3",
  "https://scontent-frt3-1.xx.fbcdn.net/v/t1.0-9/31120_122420111114653_4554442_n.jpg?_nc_cat=102&_nc_sid=09cbfe&_nc_ohc=NL_RN1qT2O4AX87N_7S&_nc_ht=scontent-frt3-1.xx&oh=b5aa96fc4f14f9a502b3bebd161916be&oe=5EE03FF3"
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
                          "Kiemelt helyek",
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
                      "Kategóriák",
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
                          "Helyek a közelben",
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
                ))));
  }
}
