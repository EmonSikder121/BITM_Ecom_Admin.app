import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationPage extends StatelessWidget {
  static const String routeName = '/notifications';
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.notificationList.length,
          itemBuilder: (context, index) {
            final notification = provider.notificationList[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                onTap: () {

                },
                tileColor:
                    notification.status ? null : Colors.grey.withOpacity(.5),
                title: Text(notification.type),
                subtitle: Text(notification.message),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigate(BuildContext context, NotificationModel notification,
      NotificationProvider provider) {

  }
}
