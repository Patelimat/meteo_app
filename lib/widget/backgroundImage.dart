import 'dart:ui';
import 'package:flutter/material.dart';


class BackgroundImage extends StatelessWidget {
  final String imagePath;


  const BackgroundImage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Affiche l'image de fond
        SizedBox.expand(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        // Applique le filtre blurry
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}