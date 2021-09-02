import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shop1/providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart ' show Orders;
import 'package:provider/provider.dart';

import 'user_products_screen.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    _onTap(index) {
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacementNamed('/');
          break;
        case 1:
          Navigator.of(context)
              .pushReplacementNamed(UserProductsScreen.routeName);
          break;
        case 2:
          Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          break;
        case 3:
          Provider.of<Auth>(context, listen: false).logout();
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('About'),
      ),
      drawer: AppDrawer(),
      body: Scaffold(
        body: new Center(
          child: new Card(
            child: new Text(
              'This program is a graduation project submitted by students Mahammed Riad Muhammad and Ali Hatem Abdulkarim, Department of Information Technology, College of Management Technology, to obtain a bachelor’s degree while it is in the development stage. We hope that we have succeeded in implementing this program.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ),
        bottomNavigationBar: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.shop), title: new Text("Shopping")),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.add_shopping_cart),
                title: new Text("Cart")),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.person), title: new Text("About")),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.account_circle),
                title: new Text("Logout")),
          ],
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.lightBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          currentIndex: 2,
        ),
      ),
    );
  }
}
