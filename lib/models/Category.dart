class Category {
  String categoryId;
  String categoryName;
  String categoryDesc;
  String parent;
  Image1 image;
  Category(
      {this.image,
      this.categoryDesc,
      this.categoryId,
      this.categoryName,
      this.parent});
  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    categoryDesc = json['categoryDesc'];
    parent = json['parent'];
    image = json['image'] != null ? Image1.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['categoryDesc'] = this.categoryDesc;
    data['parent'] = this.parent;

    return data;
  }
}

class Image1 {
  String url;
  Image1({this.url});
  Image1.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;

    return data;
  }
}
