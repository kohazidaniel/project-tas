import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/star_rating.dart';
import 'package:tas/viewmodels/customer/main_view_model.dart';

List comments = [
  {
    "img": "assets/images/cm4.jpg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe"
  },
  {
    "img": "assets/images/cm4.jpg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Joe"
  },
  {
    "img": "assets/images/cm4.jpg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Mary Jane"
  },
  {
    "img": "assets/images/cm4.jpg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Jones"
  }
];

class PlaceDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MainViewModel>.withConsumer(
      viewModel: MainViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            FlutterI18n.translate(context, "details"),
            style: TextStyle(color: primaryColor),
          ),
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3.2,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        "https://etterem.hu/img/max960/p1343n/1362941577-3763.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -10.0,
                    bottom: 3.0,
                    child: RawMaterialButton(
                      onPressed: () {},
                      fillColor: Colors.white,
                      shape: CircleBorder(),
                      elevation: 4.0,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          true ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text(
                "Y söröző",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                child: Row(
                  children: <Widget>[
                    SmoothStarRating(
                      starCount: 5,
                      color: Colors.yellow,
                      allowHalfRating: true,
                      rating: 5.0,
                      size: 10.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "5.0 (23 ${FlutterI18n.translate(context, "review")})",
                      style: TextStyle(
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.dollarSign,
                      color: primaryColor,
                      size: 12.0,
                    ),
                    Icon(
                      FontAwesomeIcons.dollarSign,
                      color: primaryColor.withOpacity(0.50),
                      size: 12.0,
                    ),
                    Icon(
                      FontAwesomeIcons.dollarSign,
                      color: primaryColor.withOpacity(0.50),
                      size: 12.0,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                FlutterI18n.translate(context, "description"),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 10.0),
              Text(
                "Nulla quis lorem ut libero malesuada feugiat. Lorem ipsum dolor "
                "sit amet, consectetur adipiscing elit. Curabitur aliquet quam "
                "id dui posuere blandit. Pellentesque in ipsum id orci porta "
                "dapibus. Vestibulum ante ipsum primis in faucibus orci luctus "
                "et ultrices posuere cubilia Curae; Donec velit neque, auctor "
                "sit amet aliquam vel, ullamcorper sit amet ligula. Donec"
                " rutrum congue leo eget malesuada. Vivamus magna justo,"
                " lacinia eget consectetur sed, convallis at tellus."
                " Vivamus suscipit tortor eget felis porttitor volutpat."
                " Donec rutrum congue leo eget malesuada."
                " Pellentesque in ipsum id orci porta dapibus.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                FlutterI18n.translate(context, "reviews"),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                itemCount: comments == null ? 0 : comments.length,
                itemBuilder: (BuildContext context, int index) {
                  Map comment = comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: AssetImage(
                        "${comment['img']}",
                      ),
                    ),
                    title: Text("${comment['name']}"),
                    subtitle: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SmoothStarRating(
                              starCount: 5,
                              color: Colors.yellow,
                              allowHalfRating: true,
                              rating: 5.0,
                              size: 12.0,
                            ),
                            SizedBox(width: 6.0),
                            Text(
                              "2020. Február 8.",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          "${comment["comment"]}",
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 50.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  child: Text(
                    FlutterI18n.translate(context, "drink_menu"),
                    style: TextStyle(color: primaryColor, fontSize: 16.0),
                  ),
                  color: primaryColor.withOpacity(0.15),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  child: Text(
                    FlutterI18n.translate(context, "book_a_table"),
                    style: TextStyle(color: backgroundColor, fontSize: 16.0),
                  ),
                  color: primaryColor,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
