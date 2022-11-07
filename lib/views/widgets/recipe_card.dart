import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  //final String title;
  //final String image;
  final String documentId;

  RecipeCard({required this.documentId});
  //RecipeCard({this.?title, this.image});

  @override
  Widget build(BuildContext context) {
    CollectionReference recipies =
        FirebaseFirestore.instance.collection('recipies');

    return FutureBuilder<DocumentSnapshot>(
      future: recipies.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data?.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Ink.image(
                    image: NetworkImage('${data['method']}'),
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.darken),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    '${data['name']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return Text("Loading..");
      }),
    );
  }
}
