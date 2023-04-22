import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/ui/widgets/component.dart';

class CategoryItemsView extends StatefulWidget {
  final itemsId;
  final subNames;
  final selectSub;
  final selectCat;

  CategoryItemsView(
      this.itemsId, this.subNames, this.selectSub, this.selectCat);

  @override
  State<StatefulWidget> createState() {
    return new CategoryItemsViewState(
        this.itemsId, this.subNames, this.selectSub, this.selectCat);
  }
}

class CategoryItemsViewState extends State<CategoryItemsView>
    with SingleTickerProviderStateMixin {
  final itemsId;
  final subNames;
  final selectSub;
  final selectCat;

  String numOfItems = "0";

  CategoryItemsViewState(
      this.itemsId, this.subNames, this.selectSub, this.selectCat);

  var _scaffoldkey = new GlobalKey<ScaffoldState>();

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(
        vsync: this, length: subNames.length, initialIndex: selectSub);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];
    var temp;

    for (var subs in itemsId) {
      temp = <Widget>[];
      subs.forEach((id) => temp.add(new Item(id)));
      items.add(new GridView.count(
        childAspectRatio: 0.6,
        crossAxisCount: 2,
        children: temp,
      ));
    }

    return new Scaffold(
        key: _scaffoldkey,
        appBar: new AppBar(
          bottom: new TabBar(
            controller: controller,
            isScrollable: true,
            tabs: new List.generate(subNames.length, (index) {
              return new Tab(text: subNames[index].toUpperCase());
            }),
          ),
          title: new Center(
            child: new Text(
              selectCat.toUpperCase(),
              style: new TextStyle(fontSize: 18.0),
            ),
          ),
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                //SearchView().showMaterialSearch(context);
              },
              icon: new Icon(Icons.search),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: new Stack(
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.shopping_cart),
                    onPressed: () {
                      _scaffoldkey.currentState.openEndDrawer();
                    },
                  ),
                  (numOfItems != "0")
                      ? new Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: new Icon(Icons.brightness_1,
                              size: 22.0, color: Colors.redAccent),
                        )
                      : new Text(""),
                  (numOfItems != "0")
                      ? new Positioned(
                          top: 2.0,
                          right: 7.5,
                          child: new Text(numOfItems,
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500)),
                        )
                      : new Text("")
                ],
              ),
            ),
          ],
        ),
        body: new TabBarView(
          controller: controller,
          children: items,
        ));
  }
}
