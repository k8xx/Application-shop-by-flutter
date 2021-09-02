import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}
