import 'package:flutter/cupertino.dart';

import 'package:farmerica/models/CartRequest.dart';
import 'package:farmerica/models/Order.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/gertProductfromapi.dart';
import 'package:farmerica/models/Products.dart';

class OrderModel extends ChangeNotifier {
  List<Orders> order = [];
  Api_Services api_services = Api_Services();
  List<CartProducts> getCartProduct() {
    List<CartProducts> cartProducts = [];
    return cartProducts;
  }

  List<Product> products = [];

  getOrder(List<CartProducts> cartProducts) async {
    int i = 0;

    while (i < 2) {
      Product product =
          await api_services.getProductsById(cartProducts[i].product_id);
      i++;

      products.add(product);
    }

    return products;
  }

  addOrder(int id, int quantity) {
    notifyListeners();
  }

  removeOrder(int id, int quantity) {
    notifyListeners();
  }

  updateOrder(int id, int quantity) {
    notifyListeners();
  }

  clearCart() {
    notifyListeners();
  }
}
