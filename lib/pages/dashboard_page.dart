import 'dart:io';

import '../models/dashboard_model.dart';
import '../pages/add_product_page.dart';
import '../pages/category_page.dart';
import '../pages/dashboard_home.dart';
import '../pages/notification_page.dart';
import '../pages/order_page.dart';
import '../pages/report_page.dart';
import '../pages/settings_page.dart';
import '../pages/view_product_page.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/authservice.dart';
import '../customwidgets/badge_view.dart';
import '../customwidgets/dashboard_item_view.dart';
import '../providers/notification_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import 'launcher_page.dart';
import 'user_list_page.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/';

  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    /*Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductProvider>(context, listen: false).getAllPurchase();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<OrderProvider>(context, listen: false).getOrders();
    Provider.of<UserProvider>(context, listen: false).getAllUsers();
    Provider.of<NotificationProvider>(context, listen: false)
        .getAllNotifications();*/
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          //childAspectRatio: 1.0,
        ),
        itemCount: dashboardModelList.length,
        itemBuilder: (context, index) {
          final model = dashboardModelList[index];
          if (model.title == 'Notification') {
            final count = 0;
            return DashboardItemView(
              model: dashboardModelList[index],
              badge: BadgeView(
                count: count,
              ),
            );
          }
          return DashboardItemView(
            model: dashboardModelList[index],
          );
        },
      ),
    );
  }
}
