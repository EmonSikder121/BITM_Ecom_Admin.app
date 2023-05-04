import 'package:ecom_pb_bitm/pages/product_details_page.dart';
import 'package:ecom_pb_bitm/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationPage extends StatelessWidget {
  static const String routeName = '/notifications';
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.notificationList.length,
          itemBuilder: (context, index) {
            final notification = provider.notificationList[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                onTap: () async {
                  EasyLoading.show(status: 'Please wait...');
                  await provider.updateNotificationStatus(notification.id, true);
                  EasyLoading.dismiss();
                  _navigate(context, notification, provider);
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
    switch(notification.type) {
      case NotificationType.comment:
        final proId = notification.commentModel!.productId;
        Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: proId);
        break;
      case NotificationType.order:

        break;
      case NotificationType.user:

        break;

    }
  }
}
