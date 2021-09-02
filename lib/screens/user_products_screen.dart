import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shop1/providers/auth.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';
import 'orders_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }


  @override
  Widget build(BuildContext context) {

    _onTap(index)
    {

      switch(index){
        case 0:
          Navigator.of(context).pushReplacementNamed('/');
          break;
        case 1:
          Navigator.of(context)
              .pushReplacementNamed(UserProductsScreen.routeName);
          break;
        case 2:
          Navigator.of(context)
              .pushReplacementNamed(OrderScreen.routeName);
          break;
        case 3:
          Provider.of<Auth>(context, listen: false).logout();
          break;
      }
    }
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
        ],
      ),

      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, int index) => Column(
                            children: [
                              UserProductItem(
                                  productsData.items[index].id,
                                  productsData.items[index].title,
                                  productsData.items[index].imageUrl),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: new BottomNavigationBar(items:
      [
        new BottomNavigationBarItem(icon: new Icon(Icons.shop),title: new Text("Shopping")),
        new BottomNavigationBarItem(icon: new Icon(Icons.add_shopping_cart),title: new Text("Cart")),
        new BottomNavigationBarItem(icon: new Icon(Icons.person),title: new Text("About")),
        new BottomNavigationBarItem(icon: new Icon(Icons.account_circle),title: new Text("Logout")),
      ],
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: 1,
      ),
    );
  }
}
