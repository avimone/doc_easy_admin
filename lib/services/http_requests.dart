import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../models/user.dart';
import 'constant.dart';
import 'exceptions.dart';

Future<http.Response> postRequest(String endpoint, Map parameters,
    {var apiPath = apiPath}) async {
  print("excesstoken = ${User.shared.bearerToken}");
  var token = User.shared.bearerToken;
  print("URL :: $API_HOST + $apiPath + $endpoint + $parameters");
  var response;
  try {
    response = await http.post(
      Uri.parse(API_HOST + apiPath + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": endpoint == "users/login" ? "" : 'Bearer $token'
      },
      body: json.encode(parameters),
    );
    print("ResponsestatusCode : ${response.statusCode}");
    print("Request response:${response.body.toString()}");
    return response;
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      /*  showToast('Error occured while communicating with Server!',
          isError: true); */
      throw new FetchDataException(
          'Error occured while communicating with Server!');
    }
  }
  //print(json.decode(response.body));
  updateReqTime();
  return response;
}

Future<http.Response> patchRequest(String endpoint, Map parameters) async {
  print("excesstoken = ${User.shared.bearerToken}");
  print("URL :: $API_HOST + $apiPath + $endpoint");
  var response;
  try {
    response = await http.patch(
      Uri.parse(API_HOST + apiPath + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": User.shared.bearerToken
      },
      body: json.encode(parameters),
    );
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      /*  showToast('Error occured while communicating with Server!',
          isError: true); */
      throw new FetchDataException(
          'Error occured while communicating with Server!');
    }
  }
  updateReqTime();
  return response;
}

Future<http.Response> putRequest(String endpoint, Map parameters) async {
  print("excesstoken = ${User.shared.bearerToken}");
  print("URL :: $API_HOST + $apiPath + $endpoint");
  var response;
  try {
    response = await http.put(
      Uri.parse(API_HOST + apiPath + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer " + User.shared.bearerToken
      },
      body: json.encode(parameters),
    );
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      /*  showToast('Error occured while communicating with Server!',
          isError: true); */
      throw new FetchDataException(
          'Error occured while communicating with Server!');
    }
  } catch (error) {
    print(error);
  }
  print(response);
  //updateReqTime();
  return response;
}

Future<http.Response> deleteRequest(String endpoint) async {
  print("excesstoken = ${User.shared.bearerToken}");
  print("URL :: $API_HOST + $apiPath + $endpoint");
  var response;
  try {
    response = await http.delete(
      Uri.parse(API_HOST + apiPath + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer " + User.shared.bearerToken
      },
      //body: json.encode(parameters),
    );
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      /*  showToast('Error occured while communicating with Server!',
          isError: true); */
      throw new FetchDataException(
          'Error occured while communicating with Server!');
    }
  }
  updateReqTime();
  return response;
}

Future<http.Response> getRequest(String endpoint, {bool isUrl = true}) async {
  print("excesstoken = ${User.shared.bearerToken}");
  print("URL :: $API_HOST + $apiPath + $endpoint");
  print("____________________________________");
  print("Access token = ${User.shared.bearerToken}");
  print("____________________________________");
  var response;
  try {
    response = await http.get(
      Uri.parse(isUrl ? endpoint : API_HOST + apiPath + endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": User.shared.bearerToken == null
            ? ""
            : "bearer " + User.shared.bearerToken
      },
    );
    if (endpoint == 'account') {
      print("account response : " + response.body.toString());
    }
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      /*  showToast('Error occured while communicating with Server!',
          isError: true); */
      throw new FetchDataException(
          'Error occured while communicating with Server!');
    }
  }
  updateReqTime();
  return response;
}

Future<http.Response> getAppConfig(String endpoint, String appToken) async {
  var response;
  // print("appconfigData = appconfigData "+appconfigData.body.toString());

  // if (appconfigData != null) {
  //   return appconfigData;
  // }

  try {
    response = await http.get(
      Uri.parse(API_HOST + apiPath + endpoint),
      headers: {"Content-Type": "application/json", "Authorization": appToken},
    );
  } on Exception catch (error) {
    if (error.toString().contains('SocketException')) {
      /*   showToast('Error occured while communicating with Server!',
          isError: true); */
      throw new FetchDataException(
          'Error occured while communicating with Server!');
    }
  }
  // appconfigData = response;
  return response;
}

void updateReqTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
      'last_req_time', DateTime.now().millisecondsSinceEpoch.toString());
}
