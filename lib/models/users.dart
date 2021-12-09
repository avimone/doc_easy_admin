// To parse this JSON data, do
//
//     final usersList = usersListFromJson(jsonString);

import 'dart:convert';

UsersList usersListFromJson(String str) => UsersList.fromJson(json.decode(str));

String usersListToJson(UsersList data) => json.encode(data.toJson());

class UsersList {
  UsersList({
    this.user,
  });

  List<User> user;

  factory UsersList.fromJson(Map<String, dynamic> json) => UsersList(
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
      };
}

class User {
  User({
    this.email,
    this.address,
    this.zip,
    this.country,
    this.height,
    this.weight,
    this.gender,
    this.emailVerified,
    this.mobileVerified,
    this.bookings,
    this.status,
    this.docVerified,
    this.requiredPictures,
    this.requiredPictures1,
    this.id,
    this.name,
    this.phone,
    this.v,
    this.userId,
  });

  String email;
  String address;
  String zip;
  String country;
  String height;
  String weight;
  String gender;
  bool emailVerified;
  bool mobileVerified;
  List<dynamic> bookings;
  String status;
  bool docVerified;
  String requiredPictures;
  String requiredPictures1;
  String id;
  String name;
  int phone;
  int v;
  String userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        address: json["address"],
        zip: json["zip"],
        country: json["country"],
        height: json["height"],
        weight: json["weight"],
        gender: json["gender"],
        emailVerified: json["emailVerified"],
        mobileVerified: json["mobileVerified"],
        bookings: List<dynamic>.from(json["bookings"].map((x) => x)),
        status: json["status"],
        docVerified: json["docVerified"],
        requiredPictures: json["requiredPictures"],
        requiredPictures1: json["requiredPictures1"],
        id: json["_id"],
        name: json["name"],
        phone: json["phone"],
        v: json["__v"],
        userId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "address": address,
        "zip": zip,
        "country": country,
        "height": height,
        "weight": weight,
        "gender": gender,
        "emailVerified": emailVerified,
        "mobileVerified": mobileVerified,
        "bookings": List<dynamic>.from(bookings.map((x) => x)),
        "status": status,
        "docVerified": docVerified,
        "requiredPictures": requiredPictures,
        "requiredPictures1": requiredPictures1,
        "_id": id,
        "name": name,
        "phone": phone,
        "__v": v,
        "id": userId,
      };
}
