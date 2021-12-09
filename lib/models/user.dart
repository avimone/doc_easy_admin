import 'package:doc_easy_admin/models/booking.dart';

class User {
  // singleton
  static final User _singleton = User._internal();
  factory User() => _singleton;
  User._internal();
  static User get shared => _singleton;

  // variables
  String name;
  String email;
  String password;
  String id;
  String bearerToken;
  int phoneNumber;
  String address;
  String country;
  String pincode;
  String gender;
  String userId;
  String height;
  String weight;
  String selectedPlan;
  String trainerId;
  String chatToken;
  String status;
  BookingElement onGoing;
  bool documentsVerified = false;
  bool loggedIn = false;
  bool emailVerified = true;
  bool mobileVerified = true;
  bool trainer = false;
}
