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
class AddMailPop extends StatelessWidget {
  /// {@macro add_todo_button}
  var name = User.shared.name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 25, right: 25),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const _AddMailPopupCard();
          }));
        },
        child: Hero(
          tag: _heroAddTodoMail,
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
                    LineIcons.at,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                  title: Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      "Change E-mail",
                      style: TextStyle(
                          fontFamily: 'Averta',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          color: Colors.blueAccent),
                    ),
                  ),
                ) /* Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    LineIcons.at,
                    size: 30,
                    color: Colors.teal[400],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Change E-mail",
                    style: TextStyle(
                        fontFamily: 'Averta',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        color: Colors.teal[400]),
                  ),
                ],
              ), */
                ),
          ),
        ),
      ),
    );
  }
}

/// Tag-value used for the add todo popup button.
const String _heroAddTodoMail = 'add-todo-hero-mail';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class _AddMailPopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  const _AddMailPopupCard({Key key}) : super(key: key);

  @override
  __AddMailPopupCardState createState() => __AddMailPopupCardState();
}

class __AddMailPopupCardState extends State<_AddMailPopupCard> {
  var _isLoading = false;
  TextEditingController _emailController = new TextEditingController();

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    var parameters = {
      "email": _emailController.text.isEmpty
          ? User.shared.email
          : _emailController.text,
      "passwordOld": User.shared.password
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
                    color: Color(0xFFffb423)),
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
                    color: Color(0xFFffb423)),
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
      child: _isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Hero(
                tag: _heroAddTodoMail,
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin, end: end);
                },
                child: Material(
                  color: Colors.red.withOpacity(0),
                  child: SingleChildScrollView(
                    child: GlassmorphicContainer(
                      margin: EdgeInsets.only(top: 0),
                      width: MediaQuery.of(context).size.width * .7,
                      height: 280,
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
                                    LineIcons.at,
                                    size: 30,
                                    color: Colors.teal[700],
                                  )),
                            ),
                            Center(
                              child: Container(
                                child: Text(
                                  "Update your mail",
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
                                "E-mail",
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
                                controller: _emailController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.white54),
                                  errorStyle: TextStyle(fontSize: 11),
                                  errorText: User.shared.emailVerified
                                      ? "your verification will be revoked \n on change Email"
                                      : null,
                                  //fillColor: Colors.white,
                                  //hoverColor: Colors.white,
                                  hintText: '${User.shared.email}',
                                  //focusColor: Colors.white,
                                  border: InputBorder.none,
                                ),
                                cursorColor: Colors.white,
                              ),
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
