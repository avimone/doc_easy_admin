import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/route_animation/custom_rect_tween.dart';
import 'package:doc_easy_admin/route_animation/hero_dialog_route.dart';
import 'package:doc_easy_admin/screens/login_screen.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:doc_easy_admin/services/constant.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:line_icons/line_icons.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
// ignore: must_be_immutable
class AddPhonePop extends StatelessWidget {
  /// {@macro add_todo_button}
  var name = User.shared.name;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 25, right: 25),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const _AddPhonePopupCard();
          }));
        },
        child: Hero(
          tag: _heroAddTodo4,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.grey.withOpacity(0.05),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Container(
                height: 50,
                child: ListTile(
                  leading: Icon(
                    LineIcons.phone,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                  title: Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      "Update Phone No",
                      style: TextStyle(
                          fontFamily: 'Averta',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          color: Colors.blueAccent),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

/// Tag-value used for the add todo popup button.
const String _heroAddTodo4 = 'add-todo-hero-3';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class _AddPhonePopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  const _AddPhonePopupCard({Key key}) : super(key: key);

  @override
  __AddPhonePopupCardState createState() => __AddPhonePopupCardState();
}

class __AddPhonePopupCardState extends State<_AddPhonePopupCard> {
  var _isLoading = false;
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _otpController = new TextEditingController();
  var loadingText = '';
  var verify = false;
  var check = '';
  void _submit() async {
    var params = {"otp": _otpController.text, "check": check};
    setState(() {
      loadingText = "verifying otp";
    });
    EasyLoading.show(status: loadingText);
    var resp = await verifyOTP(params, _phoneController.text);
    if (resp['success']) {
      setState(() {
        loadingText = "updating user";
      });

      var parameters = {
        "phone": _phoneController.text.isEmpty
            ? User.shared.phoneNumber
            : _phoneController.text,
        "passwordOld": User.shared.password
      };
      print(parameters);
      var response = await updateUser(parameters, User.shared.id);

      if (response['success']) {
        EasyLoading.dismiss();
        _phoneController.clear();
        Navigator.of(context).pop();
      } else {
        EasyLoading.dismiss();

        setState(() {
          _isLoading = false;
        });
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
                  response['message'],
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
    } else {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(resp['message'])));
    }
  }

  void verifyNumber() async {
    setState(() {
      loadingText = "Generating OTP";
    });
    EasyLoading.show(status: loadingText);
    var response = await requestOTP(_phoneController.text);
    if (response['success']) {
      EasyLoading.dismiss();
      setState(() {
        check = response['message'];
        verify = true;
      });
    } else {
      setState(() {
        verify = false;
      });
      EasyLoading.dismiss();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Hero(
                tag: _heroAddTodo4,
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin, end: end);
                },
                child: Material(
                  color: Colors.red.withOpacity(0),
                  child: SingleChildScrollView(
                    child: GlassmorphicContainer(
                      margin: EdgeInsets.only(top: 0),
                      width: MediaQuery.of(context).size.width * .7,
                      height: 300,
                      borderRadius: 10,
                      blur: 5,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFffffff).withOpacity(0.09),
                            Color(0xFFFFFFFF).withOpacity(0.05),
                          ],
                          stops: [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.teal[400].withOpacity(1),
                          Colors.lime[400].withOpacity(0.4),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      //border:
                                      //Border.all(color: Colors.teal[700], width: 2),
                                      color: Colors.red.withOpacity(0)),
                                  child: Icon(
                                    LineIcons.phone,
                                    size: 30,
                                    color: Colors.teal[700],
                                  )),
                            ),
                            Center(
                              child: Container(
                                child: Text(
                                  "Update your Phone no.",
                                  style: TextStyle(
                                      fontFamily: 'Averta',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white70),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              thickness: 0.2,
                            ),
                            Center(
                              child: Text(
                                "Phone number",
                                style: TextStyle(
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white70),
                              ),
                            ),
                            Container(
                              child: TextField(
                                controller: _phoneController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.white54),
                                  //fillColor: Colors.white,
                                  //hoverColor: Colors.white,
                                  hintText: '${User.shared.phoneNumber}',
                                  //focusColor: Colors.white,
                                  border: InputBorder.none,
                                ),
                                cursorColor: Colors.white,
                              ),
                            ),
                            verify
                                ? Container(
                                    child: TextField(
                                      controller: _otpController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintStyle:
                                            TextStyle(color: Colors.white54),
                                        //fillColor: Colors.white,
                                        //hoverColor: Colors.white,
                                        hintText: 'Enter OTP ',
                                        //focusColor: Colors.white,
                                        border: InputBorder.none,
                                      ),
                                      cursorColor: Colors.white,
                                    ),
                                  )
                                : Align(),
                            const Divider(
                              color: Colors.white,
                              thickness: 0.2,
                            ),
                            verify
                                ? Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(16.0),
                                        primary: Colors.teal[400],
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                      ),
                                      onPressed: () {
                                        _submit();
                                      },
                                      child: const Text('Submit OTP'),
                                    ),
                                  )
                                : Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(16.0),
                                        primary: Colors.teal[400],
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                      ),
                                      onPressed: () {
                                        verifyNumber();
                                      },
                                      child: const Text('Request OTP'),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
