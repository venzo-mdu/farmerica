import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/productDetails.dart';
import 'package:provider/provider.dart';

class GridViewList extends StatefulWidget {
  List<Product> product;

  GridViewList({this.product});

  @override
  State<GridViewList> createState() => _GridViewListState();
}

class _GridViewListState extends State<GridViewList> {
  int addtoCart = 0;

  Api_Services api_services = Api_Services();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const ScrollPhysics(),
        itemCount: widget.product.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int id) {
          var width = MediaQuery.of(context).size.width;
          // print('ImageURL: ${widget.product[id].images[0].src}');

          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: const BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(15))),
                  child: Stack(
                    children: <Widget>[
//Product Image
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width-40,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.product[id].images[0].src,
                            placeholder: (context, url) =>const Center(child: CircularProgressIndicator(color: Color(0xff3a9046),)),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fadeOutDuration: const Duration(milliseconds: 300),
                            fadeInDuration: const Duration(milliseconds: 300),
                          ),
                        ),
                      ),
// Product Desc
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                              color: Colors.white.withOpacity(0.75)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product[id].name,
                                  maxLines: 13,
                                  style: TextStyle(fontFamily: 'OutFit', fontWeight: FontWeight.w500, fontSize: width * 0.04, color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "₹${widget.product[id].price}",
                                  style:
                                      TextStyle(fontFamily: 'OutFit', fontWeight: FontWeight.w600, fontSize: width * 0.04, color: Color(0xff3a9046)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                            product: widget.product[id],
                          )));
            },
          );
        });
  }
}
