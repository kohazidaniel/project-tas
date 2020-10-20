import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/viewmodels/customer/profile_view_model.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProfileViewModel>.withConsumer(
        viewModel: ProfileViewModel(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundColor,
              body: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0),
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
                ],
              ),
            ));
  }
}
