import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.blueGrey.withOpacity(0.75),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 32,
          ),
        ),
      );
  }
}
