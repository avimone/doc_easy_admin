import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/screens/home_screen.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:doc_easy_admin/utilities/hex_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'nav_bar.dart';

class VerificationPage extends StatefulWidget {
  static const routeName = '/verificationPage';
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage>
    with TickerProviderStateMixin {
  var _isLoading = false;
  var loadingText;
  var args;
  StreamController<ErrorAnimationType> errorController;
  TextEditingController textEditingController = TextEditingController();
  var currentText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void registerUser(var token) async {
    setState(() {
      loadingText = "creating account";
      _isLoading = true;
    });
    EasyLoading.show(status: loadingText);

    var parameters = {
      "name": args["name"],
      "password": args["password"],
      "phone": args["number"],
      "token": token
    };

    var response = await register(parameters);

    errDialog(response);
  }

  void verify() async {
    var parameters = {"otp": currentText, "check": args['check']};
    setState(() {
      loadingText = "verifying otp";
      _isLoading = true;
    });
    EasyLoading.show(status: loadingText);
    var response = await verifyOTP(parameters, args['number']);
    if (response['success']) {
      registerUser(response['token']);
    } else {
      setState(() {
        _isLoading = false;
      });
      EasyLoading.dismiss();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("couldn't reach the server")));
      errDialog(response);
    }
  }

  void errDialog(var response) {
    if (response['success']) {
      print("logged in");

      Navigator.popAndPushNamed(context, Homepage.routeName);
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
      print(response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var number = "";
    if (ModalRoute.of(context).settings.arguments != null) {
      args = ModalRoute.of(context).settings.arguments;
      number = args['number'];
    }
    final verifyBtn = Container(
      height: 45,
      margin: EdgeInsets.symmetric(horizontal: 35.0, vertical: 30.0),
      child: RaisedButton(
        color: Colors.green.withOpacity(.8),
        splashColor: Colors.white70,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () {
          verify();
        },
        //  Navigator.of(context).pushNamed(PaymentPlans.routeName),
        //Navigator.of(context).pushNamed(InApp.routeName),
        child: Center(
          child: Text(
            "VERIFY",
            style: TextStyle(
                fontFamily: "Averta",
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: HexColor("#f1f1f2")),
          ),
        ),
      ),
    );
    AnimationController _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final Tween<double> turnsTween = Tween<double>(
      begin: 1,
      end: 2,
    );
    final resendBtn = GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          RotationTransition(
            turns: turnsTween.animate(_controller),
            child: Container(
              height: 40,
              child: Container(
                width: 20,
                height: 20,
                padding: EdgeInsets.all(1),
                child: Icon(
                  Icons.refresh,
                  size: 18,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Text("Resend code",
              style: TextStyle(
                  fontFamily: "Averta",
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal))
        ],
      ),
      onTap: () {
        _controller.forward(from: 0);
      },
    );
    final modifyNumber = GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.edit,
            size: 18,
            color: Colors.white,
          ),
          SizedBox(
            width: 10.0,
            height: 40,
          ),
          Text("Modify Number",
              style: TextStyle(
                  fontFamily: "Averta",
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal))
        ],
      ),
      onTap: () {
        // Navigator.popUntil(context,ModalRoute.withName(SignUp.routeName));
        //Navigator.of(context).pop();
      },
    );
    final signOutBtn = Container(
      alignment: Alignment.center,
      width: 82,
      height: 32,
      child: RaisedButton(
        color: Colors.white.withOpacity(.8),
        splashColor: Colors.white70,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        onPressed: () {},
        child: Text("SIGN OUT",
            style: const TextStyle(
                color: const Color(0xfff1f2f2),
                fontWeight: FontWeight.w600,
                fontFamily: "Averta",
                fontStyle: FontStyle.normal,
                fontSize: 11.0),
            textAlign: TextAlign.center),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.purple[900],
      body: SingleChildScrollView(
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: 150,
                        height: 31,
                        child: Text(
                          "Doc-Easy",
                          style: TextStyle(
                              fontFamily: "Averta",
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w400),
                        )),
                    // Padding(
                    //     padding: const EdgeInsets.only(right: 25.0),
                    //     child: signOutBtn),
                  ],
                ),
              ),
              SizedBox(height: 50.0),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    'VERIFY NUMBER',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 5.0),
                  child: SizedBox(
                    height: 65,
                    width: 65,
                    child: Icon(
                      Icons.sms,
                      color: Colors.green,
                      size: 42,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 30.0),
                child: Text(
                    "Enter the verification code sent to +91$number to continue",
                    strutStyle: StrutStyle(height: 1.2),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
              ),
              /*            Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      verificationFeild(),
                      verificationFeild(),
                      verificationFeild(),
                      verificationFeild(),
                      verificationFeild(),
                      verificationFeild(),
                    ],
                  ),*/
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: PinCodeTextField(
                  length: 6,
                  obsecureText: false,
                  autoFocus: true,
                  textInputType: TextInputType.number,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v.length < 3) {
                      return "Invalid";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveColor: Colors.green,
                      activeColor: Colors.green,
                      inactiveFillColor: Colors.white,
                      selectedColor: Colors.green,
                      selectedFillColor: Colors.white),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ), //    _isLoading ?Center(child: Column(children: [CircularProgressIndicator(color: Colors.teal,),Text(loadingText)],),) :Container(),

              verifyBtn,
              resendBtn,
              SizedBox(height: 10.0),
              modifyNumber
            ],
          ),
        ),
      ),
    );
  }

  Widget verificationFeild() => Container(
      height: 41,
      width: 33,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal[800], Colors.pink[300]],
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
          margin: EdgeInsets.all(0.7),
          height: 41,
          width: 33,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            //  border: Border.all(width: 1.0,color: )
          ),
          child: TextField(
            keyboardType: TextInputType.text,
            //validator: validateText,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.green.withOpacity(0.7)),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                border: InputBorder.none),
          )));
}
