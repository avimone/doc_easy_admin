import 'package:doc_easy_admin/providers/vehical_providers.dart';
import 'package:doc_easy_admin/screens/bookings.dart';
import 'package:doc_easy_admin/screens/details.dart';
import 'package:doc_easy_admin/screens/home_screen.dart';
import 'package:doc_easy_admin/screens/nav_bar.dart';
import 'package:doc_easy_admin/screens/otp_verification.dart';
import 'package:doc_easy_admin/screens/verification_doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import './screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
// hello
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    autoLoginState();
    super.initState();
  }

  void autoLoginState() async {}

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: VehicalProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: LoginScreen(),
          builder: EasyLoading.init(),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            Homepage.routeName: (ctx) => Homepage(),
            VerificationPage.routeName: (ctx) => VerificationPage(),
            DocVerification.routeName: (ctx) => DocVerification(),
            // ProfilePage.routeName: (ctx) => ProfilePage(),
            BookingsPage.routeName: (ctx) => BookingsPage(),
            DetailsPage.routeName: (ctx) => DetailsPage(),
          }),
    );
  }
}
