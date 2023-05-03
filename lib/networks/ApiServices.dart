import 'dart:convert';
import 'dart:io';

import 'package:farmerica/Config.dart';
import 'package:farmerica/models/CartRequest.dart';

import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/Login.dart';
import 'package:farmerica/models/Order.dart';
import 'package:farmerica/models/ParentCategory.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/models/bundledProduct.dart';
import 'package:farmerica/models/coupon.dart';

import 'package:farmerica/networks/Authorization.dart';
import 'package:farmerica/models/TokenResponse.dart';
import 'package:farmerica/models/wrongCredential.dart';

import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Api_Services {
  final client = HttpClient();
  WooCommerceAPI api;

  Api_Services() {
    api = new WooCommerceAPI(url: Config.url, consumerKey: Config.key, consumerSecret: Config.secret);
  }

  Future<Customers> createCustomer({
    String firstName,
    String lastName,
    String email,
    String username,
  }) async {
    var response = await api.postAsync(
        "${Config.urlfor}" "${Config.customerUrl}", {"email": email, "first_name": firstName, "last_name": lastName, "username": username});
    // print(response);
    Customers customer = Customers.fromJson(response);

    return customer;
  }

  Future createCustomers({String firstName, String lastName, String email, String username}) async {
    http.Response response = await http.post(
        Uri.parse(
            'https://www.farmerica.in/wp-json/wc/v3/customers?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c'),
        body: {"email": email, "first_name": firstName, "last_name": lastName, "username": username});

    String msg;
    if (response.statusCode == 200) {
      WrongCredential wrongCredential = WrongCredential.fromJson(jsonDecode(response.body));
      msg = wrongCredential.message;
      return msg;
    }
    if (response.statusCode == 201) {
      msg = "Signup successful";

      var customerDetails = Customers.fromJson(jsonDecode(response.body));
    } else {
      msg = "Your Email-ID is already exists.";
    }
    return msg;
  }

  Future getCustomers(int id) async {
    var url = "${Config.url}" "${Config.urlfor}" "${Config.customerUrl}/$id";
    var response = await api.getAsync(url);

    return response;
  }

  Future<Customers> getCustomersByMail(String mail) async {
    var url = "${Config.urlfor}customers?email=$mail";
    var response = await api.getAsync(url);

    Customers customer = Customers.fromJson(response[0]);
    // print('fromJson: ${response[0]}');
    return customer;
  }

  Future getUsernameByMail(String mail) async {
    var url = "${Config.urlfor}${Config.customerUrl}?email=$mail";
    String username;
    var response = await api.getAsync(url);
    if (response.length == 0) {
      username = null;
    } else {
      Customers customer = Customers.fromJson(response[0]);
      print('username: ${customer.firstName}');
      username = customer.username;
    }
    return username;
  }

  Future getToken(String username, String password) async {
    var url = "https://www.farmerica.in/wp-json/jwt-auth/v1/token";
    print('getToken: $url');
    var response = await http.post(
      Uri.parse(url),
      body: {"username": username, "password": password},
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else if(response.statusCode == 403){
      return jsonDecode(response.body);
    }

    // return data.token;
  }

  Future getTokenDetails(String username, String password) async {
    var url = "https://www.farmerica.in/wp-json/jwt-auth/v1/token";
    var response = await http.post(
      Uri.http(url),
      body: {"username": username, "password": password},
    );
    TokenResponses data = TokenResponses.fromJson(jsonDecode(response.body));

    print("data.token: ${data.token}");
    return data;
  }

  Future authenicateViaJWT(String username, String password) async {
    String token = "";
    var url = "https://www.farmerica.in/wp-json/jwt-auth/v1/token";
    http.Response response = await http.get(
      Uri.http(url),
      headers: {"Content-Type": "", "Accept": "", "Authorization": "Bearer $token"},
    );

    TokenResponses data = TokenResponses.fromJson(jsonDecode(response.body));
  }

  Future retrieveUserDetails(String email) async {
    var auth = "Basic" + base64Encode(utf8.encode("${Config.key}:${Config.secret}"));
    var url = "${Config.url}" "${Config.emailurl}$email";
    http.Response response = await http.get(
      Uri.http(url),
      headers: {"Content-Type": "application/json", "Accept": "application/json", "Authorization": auth},
    );

    // print(response.body);
  }

  Future<List<BundledProduct>> getBundled(int id) async {
    var url = "${Config.urlfor}" "${Config.productUrl}/$id?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c";
    var response = await api.getAsync(url);
    List<BundledProduct> bundledList = [];
    if(response is List){
      for (var item in response) {
        bundledList.add(BundledProduct.fromJson(item));
      }
    }
    print('bundledList: $bundledList');
    return bundledList;
  }


  Future<List<Coupon>> getCoupon() async {
    var url = "${Config.urlfor}" "${Config.coupons}?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c";
    var response = await api.getAsync(url);
    List<Coupon> couponList = [];
    for (var item in response) {
      couponList.add(Coupon.fromJson(item));
    }
    return couponList;
  }



  Future getProductsById(int id) async {
    var url = "${Config.url}" "${Config.urlfor}" "${Config.productUrl}/$id";
    var response = await api.getAsync(url);

    Product product = Product.fromJson(response);
    return product;
  }



  Future<List<ParentCategory>> getCategory(int parentId) async {
    var url = "${Config.urlfor}" "${Config.categoriesUrl}/$parentId";
    var response = await api.getAsync(url);

    List<ParentCategory> categoryList = [];
    for (var item in response) {
      categoryList.add(ParentCategory.fromJson(item));
    }
    return categoryList;
  }

  Future<List<Product>> getProducts(int id) async {
    var url = "${Config.urlfor}"
        "${Config.productUrl}?category=$id&per_page=100"
        "&consumer_key=${Config.key}"
        "&consumer_secret=${Config.secret}";

    var response = await api.getAsync(url);
    List<Product> productList = [];
    for (var item in response) {
      if (Product.fromJson(item).catalogVisibility == 'visible' && Product.fromJson(item).price.isNotEmpty) {
        productList.add(Product.fromJson(item));
      }
    }
    return productList;
  }

  Future<List<Orders>> getOrders() async {
    var url = "${Config.urlfor}" "${Config.orderUrl}?per_page=100";
    var response = await api.getAsync(url);
    List<Orders> orderList = [];
    for (var item in response) {
      orderList.add(Orders.fromJson(item));
    }

    return orderList;
  }

  Future<List<ParentCategory>> getCategoryById(int id) async {
    var url = "${Config.urlfor}"
        "${Config.productUrl}"
        "?categories=$id";
    var response = await api.getAsync(url);
    List<ParentCategory> categoryList = [];
    for (var item in response) {
      categoryList.add(ParentCategory.fromJson(item));
    }
    return categoryList;
  }

  Future<List<Orders>> getOrdersById(int id) async {
    var url = "${Config.urlfor}" "${Config.orderUrl}/$id";
    var response = await api.getAsync(url);
    List<Orders> orderList = [];
    for (var item in response) {
      orderList.add(Orders.fromJson(item));
    }
    return orderList;
  }

  Future<List<Orders>> getOrdersByUserId(int id) async {
    var url = "${Config.urlfor}" "${Config.orderUrl}?customer=$id";
    var response = await api.getAsync(url);
    List<Orders> orderList = [];
    for (var item in response) {
      orderList.add(Orders.fromJson(item));
    }
    for(int i=0;i<orderList.length;i++){
      print('orderList: ${orderList[i].id} => ${orderList[i].customerId}');
    }
    return orderList;
  }

  Future<List<Orders>> getOrderByUserId(int id) async {
    var url = "${Config.urlfor}" "${Config.orderUrl}?customers=$id";
    var response = await api.getAsync(url);
    List<Orders> orderList = [];
    for (var item in response) {
      orderList.add(Orders.fromJson(item));
    }
    return orderList;
  }

  Future addToCart(int id) async {
    var url = "/?${Config.addtoCartUrl}" "=$id";
    var response = await api.getAsync(url);
    return response;
  }

  Future deleteAccount(int id) async {
    var url = "${Config.urlfor}" "${Config.customerUrl}/$id?force=true";
    var response = await api.deleteAsync(url);
  }

  final String baseUrl = 'https://www.farmerica.in';
  final String consumerKey = 'ck_eedc4b30808be5c1110691e5b29f16280ebd3b72'; // Replace with your consumer key
  final String consumerSecret = 'cs_2313913bc74d5e096c91d308745b50afee52e61c'; // Replace with your consumer secret
  final int customerId = 106;

  Future<void> updateCustomers({
    String email,
    String firstName,
    String lastName,
    String phone,
    String address1,
    String address2,
    String city,
    String postcode,
    int id,
  }) async {
    final String endpoint = '/wp-json/wc/v3/customers/$id';
    final String url = baseUrl + endpoint;
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
    final http.Response response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'billing': {
          'phone': phone,
          'address_1': address1,
          'address_2': address2,
          'city': city,
          'postcode': postcode,
        },
      }),
    );
    print('updateUrl: $url');
    if (response.statusCode == 200) {
      print('Customer data updated successfully!');
      print('response: $response');
    } else {
      print('Failed to update customer data: ${response.body}');
    }
  }

  Future createOrder({
    String payment_method,
    String payment_method_title,
    String firstName,
    String lastName,
    String addressOne,
    String addressTwo,
    String city,
    String country,
    String state,
    String postcode,
    String email,
    String phone,
    String total,
    int product_id,
    int quantity,
    String delivery_type,
    String delivery_time,
    String gift_from,
    String gift_message,
    List<CartProducts> cartProducts,
    List<Coupon> coupon_lines,
    String coupon,

  }) async {
    final productsData = cartProducts
        .map((product) => {
              'product_id': product.product_id,
              'quantity': product.quantity,
            })
        .toList();

    print('Prod Qty: ${cartProducts}');
    var url = Uri.parse(
      '${Config.url}/wp-json/wc/v3/orders?consumer_key=${Config.key}&consumer_secret=${Config.secret}',
    );
    var parameters = <String, dynamic>{
      // 'customer_id':,
      'payment_method_title': 'Cash on Delivery',
      'payment_method': 'cp',
      'billing': {
        'first_name': firstName,
        'last_name': lastName,
        'address_1': addressOne,
        'address_2': addressTwo,
        'city': city,
        'country': country,
        'state': state,
        'postcode': postcode,
        'email': email,
        'phone': phone,
      },
      'shipping': {
        'first_name': firstName,
        'last_name': lastName,
        'address_1': addressOne,
        'address_2': addressTwo,
        'city': city,
        'country': country,
        'state': state,
        'postcode': postcode,
        'email': email,
        'phone': phone,
      },
      "line_items": productsData,
      'meta_data': [
        {"key": "delivery_date", "value": delivery_type},
        {
          "key": "delivery_time",
          "value": delivery_time,
        },
        {"key": "gift_from", "value": gift_from},
        {"key": "gift_message", "value": gift_message}
      ],
      'coupon_lines': [
        {
          "code": coupon.toString(),
        }
      ]
    };

    final request = await client.postUrl(url);
    request.headers.set("Content-Type", "application/json; charset=utf-8");
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final order = Orders.fromJson(json);

    print('orderResponse: ${response}');

    print('order created successfully');
    print('Order Details: ${order}');
    return order;
  }

  getProduct(List<CartProducts> cartProducts) async {
    int i = 0;
    Api_Services api_services = Api_Services();
    List<Product> products = [];

    while (i < cartProducts.length) {
      Product product = await api_services.getProductsById(cartProducts[i].product_id);
      i++;
      products.add(product);
    }

    return products;
  }

  Future loginCustomer(String email, String password) async {
    var response = await api.getAsync(Config.categoriesUrl);
    LoginResponse login = LoginResponse();
    return;
  }
}