class User{
  int? id;
  String? name;
  String? phone;
  String? image;
  String? password;
  String? token;

  User({this.id, this.image, this.name, this.phone, this.password, this.token});

  factory User.fromJSON(Map<String, dynamic> json){
    return User(
      id: json["user"]["id"],
      name: json["user"]["name"],
      phone: json["user"]["phone"],
      image: json["user"]["image"],
      password: json["user"]["password"],
      token: json["token"],
    );
  }
}