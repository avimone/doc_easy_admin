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

class AddCancelPop extends StatelessWidget {
  /// {@macro add_todo_button}
  var name = User.shared.name;
  DateTime pickup;
  var id;
  AddCancelPop(this.pickup, this.id);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: _heroAddTodoLogout,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        child: IconButton(
            onPressed: () {
              Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                return _AddCancelPopupCard(pickup, id);
              }));
            },
            icon: Icon(
              Icons.delete_outlined,
              color: Colors.redAccent,
              size: 30,
            )),
      ),
    );
  }
}

/// Tag-value used for the add todo popup button.
const String _heroAddTodoLogout = 'add-todo-hero-Cancel';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class _AddCancelPopupCard extends StatefulWidget {
  DateTime pickUp;
  DateTime today = DateTime.now();
  var id;

  /// {@macro add_todo_popup_card}
  _AddCancelPopupCard(this.pickUp, this.id);

  @override
  __AddCancelPopupCardState createState() => __AddCancelPopupCardState();
}

class __AddCancelPopupCardState extends State<_AddCancelPopupCard> {
  var _isLoading = false;
  TextEditingController _nameController = new TextEditingController();

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
  var refundT;
  var hours;
  @override
  void initState() {
    // TODO: implement initState
    _cancel();
    super.initState();
  }

  void _cancel() async {
    var diffInMin = widget.pickUp.difference(widget.today).inMinutes.ceil();
    print(widget.today);
    print(widget.pickUp);
    print(diffInMin / 60);
    var difference = (diffInMin / 60).ceil();
    hours = difference;
    print(difference);
    if (difference < 24) {
      setState(() {
        refundT = refund[0].toString();
      });
      print(refund[0]);
    } else if (difference < 336) {
      setState(() {
        refundT = refund[1].toString();
      });
    } else {
      setState(() {
        refundT = refund[2].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = 'www.gadgetspidy.com/bikerental/tnc';

    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Hero(
                tag: _heroAddTodoLogout,
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin, end: end);
                },
                child: Material(
                  color: Colors.red.withOpacity(0),
                  child: SingleChildScrollView(
                    child: GlassmorphicContainer(
                      margin: EdgeInsets.only(top: 0),
                      width: MediaQuery.of(context).size.width * .9,
                      height: 300,
                      borderRadius: 10,
                      blur: 5,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blueGrey.withOpacity(0.8),
                            Colors.amberAccent.withOpacity(0.4),
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
                        padding: const EdgeInsets.all(10.0),
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
                                    Icons.cancel_outlined,
                                    size: 30,
                                    color: Colors.teal[700],
                                  )),
                            ),
                            Center(
                              child: Container(
                                child: Text(
                                  "Do you want to cancel the booking ?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Averta',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              thickness: 0.2,
                            ),
                            refundT != null
                                ? Center(
                                    child: Container(
                                      child: Text(
                                        "you are eligible for $refundT% refund on cancelling",
                                        style: TextStyle(
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                : Align(),
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
                                  // _submit();
                                  /*    Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) => Refund(
                                                booking: widget.id,
                                                refund: refundT,
                                                hours: hours,
                                              ))); */
                                },
                                child: const Text(
                                  'YES',
                                  style: TextStyle(
                                      fontFamily: 'Averta',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.red),
                                ),
                              ),
                            ),
                            Center(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(16.0),
                                  primary: Colors.teal[400],
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  // _submit();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'NO',
                                  style: TextStyle(
                                      fontFamily: 'Averta',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black),
                                ),
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
