import 'dart:convert';

import 'package:doc_easy_admin/models/booking.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/services/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_requests.dart';

Future<Map> login(Map parameters) async {
  var response = await postRequest('users/login', parameters);
  var responseData = jsonDecode(response.body);

  print(responseData);
  if (responseData['data'] != null) {
    User.shared.loggedIn = true;
    User.shared.name = responseData['data']['name'];
    User.shared.phoneNumber = responseData['data']['phone'];
    User.shared.id = responseData['data']['userId'];
    User.shared.bearerToken = responseData['data']['token'];
    User.shared.email = responseData['data']['username'];
    User.shared.gender = responseData['data']['gender'];
    User.shared.emailVerified = responseData['data']['emailVerified'];
    User.shared.mobileVerified = responseData['data']['mobileVerified'];
    User.shared.weight = responseData['data']['weight'];
    User.shared.height = responseData['data']['height'];
    User.shared.selectedPlan = responseData['data']['selectedPlan'];
    User.shared.trainer = responseData['data']['trainer'];
    User.shared.trainerId = responseData['data']['trainerId'];
    User.shared.status = responseData['data']['status'];
    User.shared.documentsVerified = responseData['data']['docVerified'];

    // EasyLoading.dismiss();
    // EasyLoading.show(status: 'data fetched');
    // AccountProvider().getAccount();
    print("logged");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User.shared.password = parameters['password'];
    prefs.setInt('user_name', parameters['phone']);
    prefs.setString('user_pwd', parameters['password']);
    return {"success": true, "message": "Logged in successfully"};
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Login failed!"};
  }
}

Future<Map> autoLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getInt('user_name');
  var password = prefs.getString('user_pwd');
  if (email == null || password == null) {
    return {"success": false, "message": "Login failed!"};
  }
  var parameters = {"phone": email, "password": password};

  var response = await postRequest('users/login', parameters);
  var responseData = jsonDecode(response.body);

  print(responseData);
  if (responseData['data'] != null) {
    User.shared.loggedIn = true;
    User.shared.name = responseData['data']['name'];
    User.shared.phoneNumber = responseData['data']['phone'];
    User.shared.id = responseData['data']['userId'];
    User.shared.bearerToken = responseData['data']['token'];
    User.shared.email = responseData['data']['username'];
    User.shared.gender = responseData['data']['gender'];
    User.shared.emailVerified = responseData['data']['emailVerified'];
    User.shared.mobileVerified = responseData['data']['mobileVerified'];
    User.shared.weight = responseData['data']['weight'];
    User.shared.height = responseData['data']['height'];
    User.shared.selectedPlan = responseData['data']['selectedPlan'];
    User.shared.password = password;
    User.shared.trainer = responseData['data']['trainer'];
    User.shared.trainerId = responseData['data']['trainerId'];
    User.shared.status = responseData['data']['status'];
    User.shared.documentsVerified = responseData['data']['docVerified'];

    // AccountProvider().getAccount();
    print("logged");

    return {"success": true, "message": "Logged in successfully"};
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Login failed!"};
  }
}

Future<Map> register(Map parameters) async {
  var response = await postRequest('users/register', parameters);
  var responseData = jsonDecode(response.body);

  print(responseData);
  if (responseData['data'] != null) {
    User.shared.loggedIn = true;
    User.shared.name = responseData['data']['name'];
    User.shared.id = responseData['data']['userId'];
    User.shared.bearerToken = responseData['data']['token'];
    User.shared.email = responseData['data']['username'];
    User.shared.phoneNumber = responseData['data']['phone'];
    User.shared.emailVerified = responseData['data']['emailVerified'];
    User.shared.mobileVerified = responseData['data']['mobileVerified'];
    User.shared.gender = "";
    User.shared.weight = "";
    User.shared.height = "";
    User.shared.selectedPlan = "";
    User.shared.status = responseData['data']['status'];
    User.shared.documentsVerified = responseData['data']['docVerified'];

    // AccountProvider().getAccount();
    print("logged");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User.shared.password = parameters['password'];
    var str = "91" + parameters['phone'].toString();
    print(str);

    prefs.setInt('user_name', int.parse(str));
    prefs.setString('user_pwd', parameters['password']);
    return {"success": true, "message": "Sign Up successfully"};
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Sign up failed!"};
  }
}

Future<Map> updateUser(Map parameters, String id) async {
  var response = await putRequest('users/update/$id', parameters);
  var responseData = jsonDecode(response.body);

  print(responseData);
  if (responseData['data'] != null) {
    User.shared.loggedIn = true;
    User.shared.name = responseData['data']['name'];
    User.shared.id = responseData['data']['userId'];
    //User.shared.bearerToken = responseData['data']['token'];
    User.shared.email = responseData['data']['username'];
    User.shared.gender = responseData['data']['gender'];
    User.shared.emailVerified = responseData['data']['emailVerified'];
    User.shared.mobileVerified = responseData['data']['mobileVerified'];
    User.shared.weight = responseData['data']['weight'];
    User.shared.height = responseData['data']['height'];
    // AccountProvider().getAccount();
    print("logged");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (parameters['password'] != null) {
      User.shared.password = parameters['password'];
      prefs.setString('user_pwd', parameters['password']);
    }
    prefs.setString('user_name', User.shared.email);

    return {"success": true, "message": "Logged in successfully"};
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Login failed!"};
  }
}

Future<Map> verifyEmail(String id) async {
  var response = await getRequest('users/verifyEmail/$id', isUrl: false);
  var responseData = jsonDecode(response.body);

  print(responseData);
  if (responseData['data'] != null) {
    return {"success": true, "message": responseData['data']['message']};
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Login failed!"};
  }
}

Future<Map> changePassword(Map parameters) async {
  var response = await postRequest('users/forgot', parameters);
  var responseData = jsonDecode(response.body);

  print(responseData);
  if (responseData['data'] != null) {
    // AccountProvider().getAccount();
    User.shared.loggedIn = true;
    User.shared.name = responseData['data']['name'];
    User.shared.id = responseData['data']['userId'];
    User.shared.bearerToken = responseData['data']['token'];
    User.shared.email = responseData['data']['username'];
    User.shared.phoneNumber = responseData['data']['phone'];
    User.shared.emailVerified = responseData['data']['emailVerified'];
    User.shared.mobileVerified = responseData['data']['mobileVerified'];
    User.shared.gender = "";
    User.shared.weight = "";
    User.shared.height = "";
    User.shared.selectedPlan = "";
    User.shared.status = responseData['data']['status'];
    User.shared.documentsVerified = responseData['data']['docVerified'];

    // AccountProvider().getAccount();
    print("logged");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User.shared.password = parameters['password'];
    var str = "91" + parameters['phone'].toString();
    print(str);
    return {"success": true, "message": responseData['data']['message']};
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "failed!"};
  }
}
/* Future<Map> signInWithGoogle() async {
  final user = await GoogleSignInApi.login();
  GoogleSignInAuthentication googleSignInAuthentication =
      await user.authentication;

  print(googleSignInAuthentication.idToken);
  print(googleSignInAuthentication.accessToken);
  if (user == null) {
    return {"success": false, "message": "Login failed!"};
  } else {
    print(user.authentication);
    var parameters = {
      "name": user.displayName,
      "email": user.email,
      "Gid": user.id
    };

    var response = await register(parameters);
    return {"success": true, "message": "logged in"};
  }
} */

//rzp_test_OP6wvwLk0SfFZ5
Future<Map> createOrderRazorPay(var parameters) async {
  var response = await postRequest("order", parameters);
  var responseData = jsonDecode(response.body);

  print(responseData);
  if (responseData['data'] != null) {
    var options = {
      'key': responseData['data']['key'],
      'amount': responseData['data']
          ['amount'], //in the smallest currency sub-unit.
      'name': 'Bikero',
      'order_id': responseData['data']
          ['orderId'], // Generate order_id using Orders API
      'description': responseData['data']['name'],
      'timeout': 300, // in seconds
      'prefill': {'contact': User.shared.phoneNumber}
    };
    print(options);
    return {
      "success": true,
      "message": "order created successfully",
      "option": options
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Login failed!"};
  }
}

Future<Map> confirmPayment(var parameters) async {
  var response = await postRequest("verifypayment", parameters);
  var responseData = jsonDecode(response.body);

  print(responseData);
  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": "payment completed successfully",
      'days': responseData['data']['days'],
      'hours': responseData['data']['hours'],
      'pickUp': responseData['data']['pickUp'],
      'dropIn': responseData['data']['dropIn'],
      'address': responseData['data']['address'],
      'orderId': responseData['data']['orderId'],
      'ammount': responseData['data']['total_paid'],
      'time': responseData['data']['pickUp'],
      'discount': responseData['data']['discount'],
      'price_days': responseData['data']['price_days'],
      'price_hours': responseData['data']['price_hours']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Payment failed!"};
  }
}

Future<Map> cancelBooking(Map parameters, String id) async {
  var response = await putRequest('cancel/$id', parameters);
  var responseData = jsonDecode(response.body);

  print(responseData);
  if (responseData['data'] != null) {
    EasyLoading.dismiss();
    return {"success": true, "message": responseData['data']['message']};
  } else if (responseData['error'] != null) {
    EasyLoading.dismiss();

    return {"success": false, "message": responseData['error']['message']};
  } else {
    EasyLoading.dismiss();

    return {"success": false, "message": "Login failed!"};
  }
}

Future<Map> requestOTP(var number) async {
  // var number = parameters['number'];
  var response = await getRequest("otpreq/91$number", isUrl: false);
  var responseData = jsonDecode(response.body);
  print("---------- API RESPONSE ------------");
  print(responseData);
  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": responseData['data']['message'],
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": " failed!"};
  }
}

Future<Map> requestForgotOTP(var number) async {
  // var number = parameters['number'];
  var response = await getRequest("otpreq/forgot/91$number", isUrl: false);
  var responseData = jsonDecode(response.body);
  print("---------- API RESPONSE ------------");
  print(responseData);
  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": responseData['data']['message'],
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": " failed!"};
  }
}

Future<Map> verifyOTP(var parameters, var number) async {
  var response = await postRequest("otpverify/91$number", parameters);
  var responseData = jsonDecode(response.body);
  print("---------- API RESPONSE ------------");
  print(responseData);
  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": responseData['data']['message'],
      "token": responseData['data']['token']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": " failed!"};
  }
}

Future<Map> requestChatToken(var id) async {
  // var number = parameters['number'];
  var response = await getRequest("chat/token/$id", isUrl: false);
  var responseData = jsonDecode(response.body);
  if (responseData['data'] != null) {
    User.shared.chatToken = responseData['data']['token'];
    //connect(true);
    print(User.shared.chatToken);
    return {
      "success": true,
      "message": "token generated",
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Payment failed!"};
  }
}

Future<Map> requestConfig() async {
  // var number = parameters['number'];
  var response = await getRequest("users/config", isUrl: false);
  var responseData = jsonDecode(response.body);
  if (responseData['data'] != null) {
    cancellationPolicy = responseData['data']['cancellation_policy'];
    cancellationPolicyList = responseData['data']['cancellation_policy_list'];
    lateFeeList = responseData['data']['late_fee_list'];
    refund = responseData['data']['refund'];
    return {
      "success": true,
      "message": "token generated",
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Payment failed!"};
  }
}

Future<Map> requestStatus(var id) async {
  // var number = parameters['number'];
  var response = await getRequest("doctors/status/$id", isUrl: false);
  var responseData = jsonDecode(response.body);
  print("---------- API RESPONSE ------------");
  print(responseData);
  if (responseData['data'] != null) {
    //connect(true);
    return {
      "success": true,
      "message": "token generated",
      "process": responseData['data']['inProcess']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Payment failed!"};
  }
}

Future<Map> requestDocumentStatus(var id) async {
  // var number = parameters['number'];
  var response = await getRequest("users/status/$id", isUrl: false);
  var responseData = jsonDecode(response.body);
  print("---------- API RESPONSE ------------");
  print(responseData);
  if (responseData['data'] != null) {
    User.shared.status = responseData['data']['status'];
    User.shared.documentsVerified = responseData['data']['docVerified'];
    //connect(true);
    return {
      "success": true,
      "message": "status fetched",
      "process": responseData['data']['status']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Payment failed!"};
  }
}

Future<Map> requestBookingStatus(var id) async {
  // var number = parameters['number'];
  var response = await getRequest("users/statusBooking/$id", isUrl: false);
  var responseData = jsonDecode(response.body);
  print("---------- API RESPONSE ------------");
  print(responseData);
  if (responseData['data'] != null) {
    User.shared.status = responseData['data']['status'];
    User.shared.documentsVerified = responseData['data']['docVerified'];
    print(responseData['data']['onGoing']);
    if (responseData['data']['onGoing'] != null) {
      User.shared.onGoing =
          BookingElement.fromJson(responseData['data']['onGoing']);
    }
    //connect(true);
    return {
      "success": true,
      "message": "status fetched",
      "process": responseData['data']['status']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Payment failed!"};
  }
}

Future<Map> uploadDocuments(var parameters) async {
  var id = User.shared.id;
  var response = await putRequest("users/updatePic/$id", parameters);
  var responseData = jsonDecode(response.body);
  print(responseData);
  if (responseData['data'] != null) {
    return {"success": true, "message": responseData['data']['message']};
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else if (responseData['message'] != null) {
    return {"success": false, "message": responseData['message']['message']};
  } else {
    return {"success": false, "message": "Upload failed!"};
  }
}
/* Future<Map> requestCategories() async {
  // var number = parameters['number'];
  var response = await getRequest("categories", isUrl: false);
  var responseData = jsonDecode(response.body);
  if (responseData['data'] != null) {
    final category = Category.fromJson(responseData);
    print(category.data.category);

    return {
      "success": true,
      "message": "token generated",
      "category": category.data.category
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Payment failed!"};
  }
} */

/* Future<Map> requestCategoriesVideos(var id) async {
  // var number = parameters['number'];
  var response = await getRequest("videos/category/$id", isUrl: false);
  var responseData = jsonDecode(response.body);
  if (responseData['data'] != null) {
    final videosList = Video.fromJson(responseData);
    print(videosList.data.videos);

    return {
      "success": true,
      "message": "token generated",
      "video": videosList.data.videos
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "Payment failed!"};
  }
} */
Future<Map> requestVehicals() async {
  // var number = parameters['number'];
  var response = await getRequest("doctors", isUrl: false);
  var responseData = jsonDecode(response.body);
  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": "vehical fetched",
      "doctors": responseData['data']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "fetching failed!"};
  }
}

Future<Map> requestBookings() async {
  // var number = parameters['number'];
  var response = await getRequest("bookings", isUrl: false);
  var responseData = jsonDecode(response.body);

  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": "bookings fetched",
      "bookings": responseData['data']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "fetching failed!"};
  }
}

Future<Map> requestBookingsById(var id) async {
  // var number = parameters['number'];
  var response = await getRequest("bookings/$id", isUrl: false);
  var responseData = jsonDecode(response.body);

  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": "bookings fetched",
      "bookings": responseData['data']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "fetching failed!"};
  }
}

Future<Map> updateBooking(var parameters, var id) async {
  var response = await putRequest("bookings/update/$id", parameters);
  var responseData = jsonDecode(response.body);
  print(responseData);
  if (responseData['data'] != null) {
    return {"success": true, "message": responseData['data']['message']};
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else if (responseData['message'] != null) {
    return {"success": false, "message": responseData['message']['message']};
  } else {
    return {"success": false, "message": "Upload failed!"};
  }
}

Future<Map> requestUsers() async {
  // var number = parameters['number'];
  var response = await getRequest("users", isUrl: false);
  var responseData = jsonDecode(response.body);

  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": "users fetched",
      "users": responseData['data']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "fetching failed!"};
  }
}

Future<Map> requestDoctors() async {
  // var number = parameters['number'];
  var response = await getRequest("doctors", isUrl: false);
  var responseData = jsonDecode(response.body);

  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": "users fetched",
      "users": responseData['data']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "fetching failed!"};
  }
}

Future<Map> requestUsersById(var id) async {
  // var number = parameters['number'];
  var response = await getRequest("users/$id", isUrl: false);
  var responseData = jsonDecode(response.body);
  print("---------- API RESPONSE ------------");
  print(responseData);
  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": "users fetched",
      "users": responseData['data']['user']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "fetching failed!"};
  }
}

Future<Map> changeStatus(var id, var parameters) async {
  // var number = parameters['number'];
  var response = await postRequest("users/status/$id", parameters);
  var responseData = jsonDecode(response.body);

  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": "fetched",
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "fetching failed!"};
  }
}

Future<Map> createBookings(var parameters) async {
  // var number = parameters['number'];
  var response = await postRequest("bookings", parameters);
  var responseData = jsonDecode(response.body);

  if (responseData['data'] != null) {
    return {
      "success": true,
      "message": "bookings fetched",
      "bookings": responseData['data']
    };
  } else if (responseData['error'] != null) {
    return {"success": false, "message": responseData['error']['message']};
  } else {
    return {"success": false, "message": "fetching failed!"};
  }
}
