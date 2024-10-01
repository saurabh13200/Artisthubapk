import 'package:artisthub/screens/categories.dart';

import 'package:artisthub/screens/home_screen.dart';

import 'package:artisthub/screens/user.dart';
import 'package:artisthub/widgets/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../providers/cart_provider.dart';
import '../services/utils.dart';
import 'cart/cart_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
//for addding nav button below
  final List<Map<String, dynamic>> _page = [
    {
      'page': const HomeScreen(),
      'title': 'Home Screen',
    },
    {
      'page': CategoriesScreen(),
      'title': 'Categories Screen',
    },
    // {
    //   'page': const for_post(),
    //   'title': 'for_post Screen',
    // }, //for add post
    // {
    //   'page': const Socialhub(),
    //   'title': 'Socialhub Screen',
    // }, // for showing post
    {
      'page': const CartScreen(),
      'title': 'cart Screen',
    }, //for cart
    {
      'page': const UserScreen(),
      'title': 'User Screen',
    }, // for account
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_page[_selectedIndex]['title'],),
      // ),
      body: _page[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        unselectedItemColor: _isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: _isDark ? Colors.lightBlue.shade200 : Colors.black87,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          //for home icon
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Home",
          ),
          //for categories icon
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? IconlyBold.category
                : IconlyLight.category),
            label: "Categories",
          ),
          //for
          // BottomNavigationBarItem(
          //   icon: Icon(
          //       _selectedIndex == 2 ? IconlyBold.upload : IconlyLight.upload),
          //   label: "add post",
          // ),
          // //for social hub
          // BottomNavigationBarItem(
          //   icon: Icon(_selectedIndex == 3
          //       ? IconlyBold.arrowLeftCircle
          //       : IconlyLight.arrowLeftCircle),
          //   label: "Socialhub",
          // ),
          //for buy icon
          BottomNavigationBarItem(
            //copied form dependence
            icon: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -7, end: -7),
              showBadge: true,
              ignorePointer: false,
              onTap: () {},
              badgeContent: FittedBox(
                  child:
                      TextWidget(text: cartProvider.getCartItems.length.toString(), color: Colors.white, textSize: 15)),
              badgeStyle: const badges.BadgeStyle(
                shape: badges.BadgeShape.circle,
                badgeColor: Colors.blue,
                padding: EdgeInsets.all(5),
                borderSide: BorderSide(color: Colors.white, width: 2),
                elevation: 0,
              ),
              child:
                  Icon(_selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy),
            ),
            label: "cart",
          ),
          //below user
          // for user icon
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
            label: "User",
          ),
        ],
      ),
    );
  }
}
