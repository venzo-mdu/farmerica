import 'package:flutter/material.dart';

import 'package:farmerica/ui/widgets/categoriesitems.dart';

class CategoriesDetails extends StatefulWidget {
  CategoriesDetails({this.catergories});
  final catergories;
  @override
  _CategoriesDetailsState createState() => _CategoriesDetailsState();
}

class _CategoriesDetailsState extends State<CategoriesDetails> {
  @override
  Widget build(BuildContext context) {
    final catergories = widget.catergories;
    print('catergories: $catergories');
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff00AA55),
          title: Text("Categories Page"),
        ),
        body: Center(
            child: Container(
          alignment: Alignment.center,
          height: width * 0.50,
          color: Colors.white,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 10),
            scrollDirection: Axis.vertical,
            itemCount: 14,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              print('object: ${catergories[i]}');
              final category = catergories[i];
              final padding = (i == 0) ? 10.0 : 0.0;
              return new GestureDetector(
                onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     new MaterialPageRoute(
                  //        )
                  // },
                },
                child: new Container(
                  margin: new EdgeInsets.only(left: padding),
                  height: width * 0.1,
                  child: new Column(
                    children: <Widget>[
                      new CircleAvatar(
                        radius: 30,
                      ),
                      new Text(
                        category["name"],
                        style: new TextStyle(
                          fontSize: 2,
                          // fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )));
  }
}
