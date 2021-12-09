import 'package:doc_easy_admin/models/booking.dart';
import 'package:doc_easy_admin/screens/bookings.dart';
import 'package:doc_easy_admin/screens/home_screen.dart';
import 'package:doc_easy_admin/screens/settings.dart';
import 'package:doc_easy_admin/screens/verify_doctors.dart';
import 'package:doc_easy_admin/screens/verify_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Homepage extends StatefulWidget {
  static const routeName = '/homepage';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static const primaryColor = const Color(0xFFFA4D56);
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    VerifyUsers(),
    VerifyDoctor(),
    BookingsPage(),
    Settings(),
  ];

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit App");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;
    print("_+++++++++++++++++++++++++++++++++++++++");

    print(MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: Colors.black,
      /*appBar: new AppBar(
        title: new Text("Remove Back Button"),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.fullscreen_exit),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/logout");
        },
      ),*/
      /*  appBar: AppBar(
        elevation: 20,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: const Text('Home'),
      ), */
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          /*      borderRadius: BorderRadius.only(
              topRight: Radius.circular(35), topLeft: Radius.circular(35)), */
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black,
            )
          ],
        ),
        child: SafeArea(
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                //curve: Curves.easeInCubic,

                rippleColor: Colors.blue[300],
                hoverColor: Colors.blue[100],

                gap: 2,
                activeColor: Colors.blue[600],
                iconSize: screenSize < 390 ? 14 : 18,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.blue[200].withOpacity(0.3),
                color: Colors.blue[200],
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                    //backgroundColor: primaryColor[100],
                  ),
                  GButton(
                    icon: Icons.chat,
                    text: 'Trainer',
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                  ),
                  GButton(
                    icon: Icons.verified_user,
                    text: 'Bookings',
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Settings',
                    iconActiveColor: Colors.white,
                    textColor: Colors.white,
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
