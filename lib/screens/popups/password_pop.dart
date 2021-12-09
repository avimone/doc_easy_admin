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
class AddPassPop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 25, right: 25),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const _AddPassPopupCard();
          }));
        },
        child: Hero(
          tag: _heroAddTodo2,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.grey.withOpacity(0.05),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Container(

                //decoration: BoxDecoration(
                //color: Colors.white.withOpacity(10)),
                height: 50,
                child: ListTile(
                  leading: Icon(
                    LineIcons.starOfLife,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                  title: Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      "Change password",
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

const String _heroAddTodo2 = 'add-todo-hero-1';

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class _AddPassPopupCard extends StatefulWidget {
  const _AddPassPopupCard({Key key}) : super(key: key);

  @override
  __AddPassPopupCardState createState() => __AddPassPopupCardState();
}

class __AddPassPopupCardState extends State<_AddPassPopupCard> {
  var name = User.shared.name;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var newPassword = "";
  TextEditingController _oldPasswordController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _cofirmPasswordController = new TextEditingController();
  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    var parameters = {
      "passwordOld": _oldPasswordController.text,
      "password": newPassword
    };
    print(parameters);
    var response = await updateUser(parameters, User.shared.id);

    if (response['success']) {
      Navigator.of(context).pop();
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo2,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Colors.red.withOpacity(0),
            child: SingleChildScrollView(
              child: GlassmorphicContainer(
                margin: EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width * .7,
                height: 395,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                              LineIcons.starOfLife,
                              size: 50,
                              color: Colors.teal[700],
                            )),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            "Change Password",
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
                      Column(
                        children: [
                          Container(
                            child: TextField(
                              controller: _oldPasswordController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white54),
                                errorText: _oldPasswordController.text.isEmpty
                                    ? "required"
                                    : null,
                                //fillColor: Colors.white,
                                //hoverColor: Colors.white,
                                hintText: 'Current Password',
                                //focusColor: Colors.white,
                                border: InputBorder.none,
                              ),
                              cursorColor: Colors.white,
                            ),
                          ),
                          Container(
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  newPassword = _newPasswordController.text;
                                });
                              },
                              controller: _newPasswordController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white54),
                                //fillColor: Colors.white,
                                //hoverColor: Colors.white,
                                hintText: 'New Password',
                                //focusColor: Colors.white,
                                border: InputBorder.none,
                              ),
                              cursorColor: Colors.white,
                            ),
                          ),
                          Container(
                            child: TextField(
                              controller: _cofirmPasswordController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                errorText: _cofirmPasswordController.text !=
                                        newPassword
                                    ? "Password does not match "
                                    : null,
                                hintStyle: TextStyle(color: Colors.white54),
                                //fillColor: Colors.white,
                                //hoverColor: Colors.white,
                                hintText: 'Confirm New Password',
                                //focusColor: Colors.white,
                                border: InputBorder.none,
                              ),
                              cursorColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.2,
                      ),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            primary: Colors.teal[400],
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            if (newPassword == _cofirmPasswordController.text)
                              _submit();
                          },
                          child: const Text('Save'),
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
