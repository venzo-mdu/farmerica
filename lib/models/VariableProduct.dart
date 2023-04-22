class VariableProduct {
  int id;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  List<Attributes> attributes;
  VariableProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json[' regularPrice '];
    salePrice = json['salePrice'];
    if (json['attributes'] != null) {
      attributes = List<Attributes>();
      json['attributes'].forEach((v) {
        attributes.add(Attributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data[' regularPrice '] = this.regularPrice;
    data['salePrice'] = this.salePrice;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attributes {
  int id;
  String name;
  int position;
  bool visible;
  bool variation;
  List<String> options;

  Attributes(
      {this.id,
      this.name,
      this.position,
      this.visible,
      this.variation,
      this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    visible = json['visible'];
    variation = json['variation'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['variation'] = this.variation;
    data['options'] = this.options;
    return data;
  }
}
