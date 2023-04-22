class CustomerModels {
  String email;
  String firstName;
  String lastName;
  String password;

  CustomerModels({this.email, this.firstName, this.lastName, this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'username': email
    });
    return map;
  }
}
