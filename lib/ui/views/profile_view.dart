import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/models/restaurant.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/opening_hours_select.dart';
import 'package:tas/viewmodels/profile_view_model.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (model) => model.getRestaurant(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: model.getUser().userRole == 'RESTAURANT'
            ? AppBar(
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
                  FlutterI18n.translate(context, "profile"),
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                elevation: 2.0,
              )
            : PreferredSize(
                child: SizedBox.shrink(),
                preferredSize: Size(0, 0),
              ),
        body: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0),
                  child: Image.asset(
                    "assets/images/cm4.jpg",
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            model.getUser().fullName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            model.getUser().email,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () => model.signOut(),
                            child: Text(
                              FlutterI18n.translate(context, "signout"),
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  flex: 3,
                ),
              ],
            ),
            Divider(),
            Container(height: 15.0),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                FlutterI18n.translate(context, "account_information")
                    .toUpperCase(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(
                FlutterI18n.translate(context, "full_name"),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                model.getUser().fullName,
              ),
            ),
            ListTile(
              title: Text(
                FlutterI18n.translate(context, "email"),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                model.getUser().email,
              ),
            ),
            ListTile(
              title: Text(
                FlutterI18n.translate(context, "language"),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(model.getLanguage(context)),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                ),
                onPressed: () async {
                  model.askForLang(context);
                },
              ),
            ),
            model.getUser().userRole == 'RESTAURANT'
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 15.0),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'VENDÉGLETÓHELY ADATAI',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FutureBuilder<Restaurant>(
                        future: model.getRestaurant(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Restaurant> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              ListTile(
                                title: Text(
                                  FlutterI18n.translate(context, "name"),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  snapshot.data.name,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  FlutterI18n.translate(context, "description"),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  snapshot.data.description,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  FlutterI18n.translate(context, "address"),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  snapshot.data.address,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  FlutterI18n.translate(
                                    context,
                                    "opening_hours",
                                  ),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                trailing: OpeningHoursSelect(
                                  closingTime: model.closingTime,
                                  openingTime: model.openingTime,
                                  closingTap: () => model.selectTime(
                                    context: context,
                                    isClosingTime: true,
                                  ),
                                  openingTap: () => model.selectTime(
                                    context: context,
                                  ),
                                ),
                              ),
                            ];
                          } else {
                            children = <Widget>[
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                enabled: true,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    itemBuilder: (_, __) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 60.0,
                                          height: 17.0,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: 150.0,
                                          height: 16.0,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ];
                          }
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: children,
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
