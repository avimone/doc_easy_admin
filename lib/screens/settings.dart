import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/screens/popups/email_pop.dart';
import 'package:doc_easy_admin/screens/popups/help_pop.dart';
import 'package:doc_easy_admin/screens/popups/logout_pop.dart';
import 'package:doc_easy_admin/screens/popups/name_pop.dart';
import 'package:doc_easy_admin/screens/popups/password_pop.dart';
import 'package:doc_easy_admin/screens/popups/phone_pop.dart';
import 'package:doc_easy_admin/screens/popups/trainer_pop.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var name = User.shared.name;
  var mail = User.shared.email;
  var num = User.shared.phoneNumber;
  var height = User.shared.height;
  var weight = User.shared.weight;
  var plan = User.shared.selectedPlan;
  //TextEditingController _nameController = TextEditingController(text: "$name");
  bool _isEnable = false;

  /// this will delete cache
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  /// this will delete app's storage
  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.dismiss();
    requestDocumentStatus(User.shared.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, top: 50),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(
                        fontFamily: 'Averta',
                        fontWeight: FontWeight.w700,
                        fontSize: 27,
                        fontStyle: FontStyle.normal,
                        color: Colors.blueAccent),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Tweak all of your account related settings here.",
                    style: TextStyle(
                        fontFamily: 'Averta',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey[600]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                    indent: 3,
                    endIndent: 20,
                  ),
                  GlassmorphicContainer(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.only(top: 15, right: 15),
                      width: MediaQuery.of(context).size.width,
                      height: 475,
                      borderRadius: 10,
                      blur: 20,
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
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.2),
                          Color((0xFFFFFFFF)).withOpacity(0.2),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: AddNamePop(),
                            ),
                            Container(
                              child: AddPassPop(),
                            ),
                            Container(
                              child: AddPhonePop(),
                            ),
                            Container(
                              child: AddMailPop(),
                            ),
                            Container(
                              child: AddTrainerPop(),
                            ),
                            Container(
                              child: AddHelpPop(),
                            ),
                            Container(
                              child: AddLogoutPop(),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            /*  IconButton(
                                iconSize: 40,
                                icon: Icon(Icons.logout),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.clear();
                                  if (User.shared.trainer == true) {
                                    disconnect();
                                  }
                                  _deleteCacheDir();
                                  _deleteAppDir();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LoginScreen()),
                                    ModalRoute.withName('/'),
                                  );
                                }), */
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                "1.2.1v @Gadgetspidy",
                                style: TextStyle(
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 9,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.grey[800]),
                              ),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
