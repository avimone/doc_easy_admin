import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/screens/home_screen.dart';
import 'package:doc_easy_admin/screens/nav_bar.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'otp_verification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();
  static const routeName = '/loginscreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var signUp = false;
  var _isLoading = false;
  var country = "91";
  var forgot = false;

  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();

//////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoLoginState();
  }

  void autoLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getInt('user_name');
    var password = prefs.getString('user_pwd');
    if (email == null || password == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    EasyLoading.show(status: "auto loging");
    await autoLogin();
    print(User.shared.loggedIn);
    if (User.shared.loggedIn) {
      print("logged in");

      Navigator.popAndPushNamed(context, Homepage.routeName);
    } else {
      setState(() {
        _isLoading = false;
      });
      EasyLoading.dismiss();
    }
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    EasyLoading.show(status: "loging in");
    var parameters = {
      "phone": int.parse("$country" + _phoneNumberController.text),
      "password": _passwordController.text
    };
    var response = await login(parameters);

    print(response);
    /*  if (response['success']) {
      EasyLoading.dismiss();
      Navigator.popAndPushNamed(context, Homepage.routeName);
    } */
    errDialog(response);
  }

  void errDialog(var response) {
    if (response['success'] == true) {
      print("logged in");

      EasyLoading.dismiss();

      Navigator.popAndPushNamed(context, Homepage.routeName);

      //   Navigator.popAndPushNamed(context, ExtraDetails.routeName);

    } else {
      setState(() {
        _isLoading = false;
      });
      EasyLoading.dismiss();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        headerAnimationLoop: true,
        animType: AnimType.RIGHSLIDE,
        dismissOnBackKeyPress: true,
        dialogBackgroundColor: Colors.transparent,
        borderSide: BorderSide(color: Colors.white),
        // desc: response['message'],
        body: Column(
          children: [
            Container(
              child: Text(
                "Error",
                style: TextStyle(
                    fontFamily: 'Averta',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFF56E39F)),
              ),
            ),
            Container(
              child: Text(
                response['message'].toString(),
                style: TextStyle(
                    fontFamily: 'Averta',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFF56E39F)),
              ),
            ),
          ],
        ),
        btnOkOnPress: () {},
      )..show();
      //    print(response['message']);
    }
  }

  void registerProcess() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      EasyLoading.show(status: "Generating OTP");
      var response = await requestOTP(_phoneNumberController.text);
      if (response['success']) {
        EasyLoading.dismiss();
        Navigator.popAndPushNamed(context, VerificationPage.routeName,
            arguments: {
              "number": _phoneNumberController.text,
              "name": _nameController.text,
              "password": _passwordController.text,
              "check": response['message']
            });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("couldn't reach the server")));
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        headerAnimationLoop: true,
        animType: AnimType.RIGHSLIDE,
        dismissOnBackKeyPress: true,
        dialogBackgroundColor: Colors.transparent,
        borderSide: BorderSide(color: Colors.white),
        //desc: 'Dialog description here.............',
        body: Container(
          child: Text(
            "Password does not match",
            style: TextStyle(
                fontFamily: 'Averta',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                fontStyle: FontStyle.normal,
                color: Color(0xFF56E39F)),
          ),
        ),
        btnOkOnPress: () {},
      )..show();
    }
  }

  void forgotProcess() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      EasyLoading.show(status: "Generating OTP");
      var response = await requestForgotOTP(_phoneNumberController.text);
      if (response['success']) {
        EasyLoading.dismiss();
        Navigator.popAndPushNamed(context, VerificationPage.routeName,
            arguments: {
              "number": _phoneNumberController.text,
              "name": _nameController.text,
              "password": _passwordController.text,
              "check": response['message'],
              "forgot": true
            });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("couldn't reach the server")));
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        headerAnimationLoop: true,
        animType: AnimType.RIGHSLIDE,
        dismissOnBackKeyPress: true,
        dialogBackgroundColor: Colors.transparent,
        borderSide: BorderSide(color: Colors.white),
        //desc: 'Dialog description here.............',
        body: Container(
          child: Text(
            "Password does not match",
            style: TextStyle(
                fontFamily: 'Averta',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                fontStyle: FontStyle.normal,
                color: Color(0xFF56E39F)),
          ),
        ),
        btnOkOnPress: () {},
      )..show();
    }
  }

//////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .2, left: 0),
                child: Text(
                  signUp ? "Create an Account" : "Login",
                  style: TextStyle(
                      fontFamily: 'Averta',
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      fontStyle: FontStyle.normal,
                      color: Colors.white),
                )),
            SizedBox(
              height: 20,
            ),
            signUp
                ? Column(
                    children: [
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              color: Colors.white),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                                hintText: 'Enter your name'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  )
                : Container(),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Colors.white),
                child: TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone Number',
                      hintText: 'Enter valid Number'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Colors.white),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: forgot ? 'New Password' : 'Password',
                  ),
                ),
              ),
            ),
            signUp
                ? Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              color: Colors.white),
                          child: TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText: 'Confirm Password',
                                hintText: forgot
                                    ? 'Confirm New Password'
                                    : 'Confirm Password'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  )
                : forgot
                    ? Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  color: Colors.white),
                              child: TextField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    // labelText: 'Confirm Password',
                                    hintText: forgot
                                        ? 'Confirm New Password'
                                        : 'Confirm Password'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: () {
                              //TODO FORGOT PASSWORD SCREEN GOES HERE
                              setState(() {
                                forgot = true;
                                signUp = false;
                                print("terw");
                              });
                            },
                            child: Text(
                              signUp ? "" : 'Forgot Password',
                              style: TextStyle(
                                  fontFamily: 'Averta',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  if (signUp) {
                    // registerUser()

                    registerProcess();
                  } else if (forgot) {
                    forgotProcess();
                  } else {
                    loginUser();
                  }
                },
                child: Text(
                  signUp
                      ? "SignUp"
                      : forgot
                          ? "Verify"
                          : "Login",
                  style: TextStyle(
                      fontFamily: 'Averta',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  signUp = !signUp;
                  if (signUp) {
                    forgot = false;
                  }
                });
              },
              child: Text(
                signUp
                    ? 'Already have an account? Login'
                    : 'New User? Create Account',
                style: TextStyle(
                    fontFamily: 'Averta',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 15),
              ),
            ),
            forgot
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        signUp = false;
                        forgot = false;
                        if (signUp) {
                          forgot = false;
                          print("terw");
                        } else {}
                      });
                    },
                    child: Text(
                      "Already have an account ? Login",
                      style: TextStyle(
                          fontFamily: 'Averta',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          color: Colors.white),
                    ),
                  )
                : Align(),
          ],
        ),
      ),
    );
  }
}
