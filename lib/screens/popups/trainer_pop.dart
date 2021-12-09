import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/route_animation/custom_rect_tween.dart';
import 'package:doc_easy_admin/route_animation/hero_dialog_route.dart';
import 'package:doc_easy_admin/screens/login_screen.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:doc_easy_admin/services/constant.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:line_icons/line_icons.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AddTrainerPop extends StatelessWidget {
  /// {@macro add_todo_button}
  var name = User.shared.name;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 25, right: 25),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const _AddTrainerPopupCard();
          }));
        },
        child: Hero(
          tag: _heroAddTodoTrainer,
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
                    LineIcons.userTie,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                  title: Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      "Terms And Conditions",
                      style: TextStyle(
                          fontFamily: 'Averta',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          color: Colors.blueAccent),
                    ),
                  ),
                )
                /* Row(
                //crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  Icon(
                    LineIcons.userTie,
                    size: 30,
                    color: Colors.teal[400],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Trainer related",
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
const String _heroAddTodoTrainer = 'add-todo-hero-Trainer';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class _AddTrainerPopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  const _AddTrainerPopupCard({Key key}) : super(key: key);

  @override
  __AddTrainerPopupCardState createState() => __AddTrainerPopupCardState();
}

class __AddTrainerPopupCardState extends State<_AddTrainerPopupCard> {
  var _isLoading = false;
  TextEditingController _nameController = new TextEditingController();

  String _url = "https://gadgetspidy.com/bike-rental-terms-and-conditions/";
  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
/*   void _submit() async {
    setState(() {
      _isLoading = true;
    });
    print(User.shared.name);
    print(_nameController.text);
    var parameters = {
      "name": _nameController.text.isEmpty
          ? User.shared.name
          : _nameController.text,
    };
    print(parameters);
    var response = await updateUser(parameters, User.shared.id);

    if (response['success']) {
      _nameController.clear();
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
  } */

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Hero(
                tag: _heroAddTodoTrainer,
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
                                    LineIcons.userTie,
                                    size: 30,
                                    color: Colors.teal[700],
                                  )),
                            ),
                            Center(
                              child: Container(
                                child: Text(
                                  "Terms and Conditions",
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
                                "Link",
                                style: TextStyle(
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white70),
                              ),
                            ),
                            Container(
                              child: Text(
                                'https://gadgetspidy.com/bike-rental-terms-and-conditions/',
                                style: TextStyle(color: Colors.white),
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
                                  primary: Colors.teal[900],
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          "https://gadgetspidy.com/bike-rental-terms-and-conditions/"));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Copied!")));

                                  // _submit();
                                  /*  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => WebViewTC(
                                          'https://www.gadgetspidy.com/'))); */
                                },
                                child: const Text('Copy'),
                              ),
                            ),
                            Center(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(16.0),
                                  primary: Colors.teal[900],
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  _launchURL();
                                  // _submit();
                                  /*  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => WebViewTC(
                                          'https://www.gadgetspidy.com/'))); */
                                },
                                child: const Text('Read'),
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
