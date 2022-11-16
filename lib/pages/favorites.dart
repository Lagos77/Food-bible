import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbible/models/constants.dart';
import 'package:foodbible/models/recipe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbible/models/user.dart';
import 'package:foodbible/views/widgets/favoritesCard.dart';
import 'package:foodbible/views/widgets/recipe_card.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    getFavList();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List favList = [];

  bool checkifLoggedin() {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return true;
    }
    return false;
  }

  //var favList = [];

  Future<List> getFavList() async {
    // var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    favList = docSnapshot.data()?['favorites'];
    return favList;
  }

  @override
  Widget build(BuildContext context) {
    return !checkifLoggedin()
        ? Column(
            children: [
              Text("You need yto log in to see your favorites"),
            ],
          )
        : Scaffold(
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Searchbar code

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('recipies')
                          .snapshots(),
                      builder: (context, snapshots) {
                        return (snapshots.connectionState ==
                                ConnectionState.waiting)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: snapshots.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshots.data!.docs[index].data()
                                      as Map<String, dynamic>;

                                  if (favList.isEmpty) {
                                    print("Listi s empty");
                                  }
                                  if (favList.contains(snapshots
                                      .data!.docs[index].reference.id)) {
                                    return RecipeCard(
                                        snapshots.data!.docs[index]);
                                  }
                                  return Container();
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
