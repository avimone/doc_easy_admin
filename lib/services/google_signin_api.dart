import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );
/* GoogleSignin.configure({
  webClientId:
    'YOUR_CLIENT_ID',
}); */
  static Future<GoogleSignInAccount> login() {
    return _googleSignIn.signIn();
  }
}
