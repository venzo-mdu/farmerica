import 'package:cached_network_image/cached_network_image.dart';
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: color),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CachedNetworkImage(
              width: width,
              height: height,
              color: color,
              imageUrl: images,
              placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                color: Color(0xff3a9046),
              )),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fadeOutDuration: const Duration(milliseconds: 300),
              fadeInDuration: const Duration(milliseconds: 300),
            ),

            //   Image.network(
            //       images,
            //     width: width,
            //     height: height,
            //     color: color,
            //   ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(text,
                style: TextStyle(
                  fontSize: 25,
                  color: color,
                  fontWeight: FontWeight.w600,
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(subtitles,
                style: TextStyle(
                  fontSize: 25,
                  color: color,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ],
      ),
    );
  }
}
