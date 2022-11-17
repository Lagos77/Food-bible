import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodbible/pages/recipe_detail.dart';
import 'dart:developer';

class RecipeCard extends StatelessWidget {
  var documentId;

  RecipeCard(this.documentId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
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
                image: NetworkImage('${documentId["mainImage"]}'),
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
                height: 150,
                fit: BoxFit.cover,
              ),
              Text(
                '${documentId["name"]}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(documentId),
          ),
        );
      },
    );
  }
}
