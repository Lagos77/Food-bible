import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbible/pages/create_recipe.dart';
import 'package:foodbible/pages/favorites.dart';
import 'package:foodbible/pages/home.dart';
import 'package:foodbible/pages/singin.dart';
import 'package:foodbible/pages/singup.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  final switchScreens = [
    HomePage(),
    CreateRecipePage(),
    SignUp(),
    SignIn(),
    Favorites(),
  ];

  Future<void> signOutEmail() async {
    await FirebaseAuth.instance.signOut();
  }

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
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              // Add more items to the menu if needed
              PopupMenuItem(
                child: Row(
                  children: const [Icon(Icons.logout), Text("Sign Out")],
                ),
                onTap: signOutEmail,
              ),
            ],
          )
        ],
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
            icon: Icon(Icons.app_registration),
            selectedIcon: Icon(Icons.app_registration),
            label: "SignUp",
          ),
          NavigationDestination(
            icon: Icon(Icons.door_front_door),
            selectedIcon: Icon(Icons.door_front_door),
            label: "SignIn",
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
