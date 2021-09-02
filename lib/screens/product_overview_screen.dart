import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop1/providers/auth.dart';
import 'package:shop1/providers/products.dart';
import 'package:shop1/screens/user_products_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';
import '../screens/orders_screen.dart';

enum FilterOpation { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _showOlnyFavorites = false;
  // var _isInt = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(() => _isLoading = false))
        .catchError((_) => setState(
              () => _isLoading = false,
            ));
  }

  _onTap( index)
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

  @override
  Widget build(BuildContext context) {
    var _key = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _key,
      appBar: new AppBar(
        title: new Text('My Shop'),backgroundColor : Colors.lightBlue,
        actions: [
          PopupMenuButton(
              onSelected: (FilterOpation selectedVal) {
                setState(() {
                  if (selectedVal == FilterOpation.Favorites) {
                    _showOlnyFavorites = true;
                  } else {
                    _showOlnyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Olny Favorites'),
                      value: FilterOpation.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOpation.All,
                    ),
                  ]),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOlnyFavorites),
      drawer: AppDrawer(),
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
        currentIndex:0,
      ),

    );
  }
}
