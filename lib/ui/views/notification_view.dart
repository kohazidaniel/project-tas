import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/models/tas_notification.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/widgets/busy_overlay.dart';
import 'package:tas/viewmodels/notifications_view_model.dart';

class NotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            FlutterI18n.translate(context, "notifications"),
            style: TextStyle(color: primaryColor),
          ),
          elevation: 0.0,
        ),
        body: StreamBuilder<List<TasNotification>>(
          stream: model.listenNotificationList(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<TasNotification>> snapshot,
          ) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    TasNotification notification = snapshot.data[index];
                    return Column(
                      children: [
                        Visibility(
                          visible: index != 0,
                          child: Divider(),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(notification.content),
                          onTap: () => model.navToNotificationRoute(
                            notification,
                          ),
                          onLongPress: () => model.deleteNotification(
                            notification.id,
                          ),
                          trailing: notification.seen
                              ? SizedBox.shrink()
                              : Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: 10,
                                    maxHeight: 10,
                                  ),
                                ),
                        )
                      ],
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64.0,
                        color: Colors.grey[400],
                      ),
                      Text(
                        FlutterI18n.translate(context, 'no_notifications'),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              }
            } else {
              return BusyOverlay();
            }
          },
        ),
      ),
    );
  }
}
