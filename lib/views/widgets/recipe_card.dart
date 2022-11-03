import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            image: NetworkImage(
                "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=768,574"),
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.darken),
            height: 240,
            fit: BoxFit.cover,
          ),
          const Text(
            "Enter firebase title here",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          )
        ],
      ),
    );
  }
}
