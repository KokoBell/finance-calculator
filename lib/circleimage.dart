import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CircleImage(
    this.imageProvider, {
    this.radius = 10,
  });

  final double radius;
  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    // wrapped around a column so that the avatar doesn't stretch
    return Column( 
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: radius,
          backgroundImage: imageProvider,
        )
      ],
    );
  }
}