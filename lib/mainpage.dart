import 'package:flutter/material.dart';
import 'package:foodbible/pages/home.dart';
import 'package:foodbible/pages/test2.dart';
import 'package:foodbible/pages/test3.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final switchScreens = [
    HomePage(),
    Test2(), // Must be replaced with "Create Recipe Widget"
    Test3(), // Must be replaced with "Favorite Widget"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.restaurant_menu),
            SizedBox(
              width: 10,
            ),
            Text('Food Bible')
          ],
        ),
      ),
      body: switchScreens[index],
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        animationDuration: const Duration(seconds: 1),
        onDestinationSelected: (index) => setState(() => this.index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.create),
            selectedIcon: Icon(Icons.create),
            label: "Create recipe",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            selectedIcon: Icon(Icons.favorite),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
