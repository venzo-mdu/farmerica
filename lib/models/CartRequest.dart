class CartResponseModel {
  bool status;
  List<CartItem> data;

  CartResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['products'] != null) {
      data = new List<CartItem>();
      json['products'].forEach((v) {
        data.add(CartItem.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class CartProducts {
  int product_id;
  int quantity;
  String price;
  String name;
  String image;

  CartProducts({
    this.product_id,
    this.quantity,
    this.name,
    this.price,
    this.image
  });
  CartProducts.fromJson(Map<String, dynamic> json) {
    product_id = json['product_id'];
    quantity = json['quantity'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product_id'] = this.product_id;
    data['quantity'] = this.quantity;
    data['name'] = this.name;
    data['price'] = this.price;
    data['image'] = this.image;

    return data;
  }
}

class CartItem {
  int productId;
  String productName;
  String productRgularPrice;
  String productSalePrice;
  String thumbnails;
  int qty;
  double lineSubTotal;
  double lineTotal;
  String attribute;
  String attributeValue;
  int variationId;
  CartItem(
      {this.productId,
      this.qty,
      this.thumbnails,
      this.productName,
      this.lineSubTotal,
      this.lineTotal,
      this.productRgularPrice,
      this.productSalePrice,
      this.attribute,
      this.attributeValue,
      this.variationId});
  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productRgularPrice = json['productRgularPrice'];
    productSalePrice = json['productSalePrice'];
    thumbnails = json['thumbnails'];
    qty = json['qty'];
    lineTotal = json['lineTotal'];
    lineSubTotal = json['lineSubTotal'];
    attribute = (json['attribute'].toString() != "[]")
        ? Map<String, dynamic>.from(json['attribute']).keys.first.toString()
        : "";
    attributeValue = (json['attribute'].toString() != "[]")
        ? Map<String, dynamic>.from(json['attribute']).values.first.toString()
        : "";
    variationId = json['variationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['productId '] = this.productId;
    data['productName'] = this.productName;
    data['productRgularPrice'] = this.productRgularPrice;
    data['productSalePrice'] = this.productSalePrice;
    data['thumbnails'] = this.thumbnails;
    data['qty'] = this.qty;
    data['lineTotal'] = this.lineTotal;
    data['lineSubTotal'] = this.lineSubTotal;
    data['attribute'] = this.attribute;
    data['attributeValue'] = this.attributeValue;
    data['variationId'] = this.variationId;

    return data;
  }
}
