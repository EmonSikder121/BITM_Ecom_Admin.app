import 'package:flutter/material.dart';

import '../auth/authservice.dart';
import 'login_page.dart';

class LauncherPage extends StatelessWidget {
  static const String routeName = '/launcher';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
