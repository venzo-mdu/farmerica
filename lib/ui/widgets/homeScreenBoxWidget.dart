import 'package:flutter/material.dart';

class HomeScreenBoxWidget extends StatelessWidget {
  final double height;
  final double width;
  Color color;
  String images;
  String text;
  String subtitles;

  HomeScreenBoxWidget({
    Key key,
    this.height,
    this.width,
    this.color,
    this.text,
    this.images,
    this.subtitles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
            child: Image.network(
                images,
              width: width,
              height: height,
              color: color,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              text, style: TextStyle(fontSize: 25, color: color, fontWeight: FontWeight.w600,)
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
                subtitles, style: TextStyle(fontSize: 25, color: color, fontWeight: FontWeight.w600,)
            ),
          ),
        ],
      ),

    );
  }
}