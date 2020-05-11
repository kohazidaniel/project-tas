import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/viewmodels/notifications_view_model.dart';

class NotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NotificationViewModel>.withConsumer(
        viewModel: NotificationViewModel(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: backgroundColor,
                leading: IconButton(
                  icon: Icon(
                    Icons.keyboard_backspace,
                    color: primaryColor,
                  ),
                  onPressed: () => model.navigationService.pop(),
                ),
                centerTitle: true,
                title: Text(
                  "Notifications",
                  style: TextStyle(color: primaryColor),
                ),
                elevation: 0.0,
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                      title: Text("Your Order has been delivered successfully"),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                      title: Text("Error processing your order"),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.directions_bike,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                          "You order has been processed and will be delivered shortly"),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                      ),
                      title: Text("Please Verify your email address"),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ));
  }
}
