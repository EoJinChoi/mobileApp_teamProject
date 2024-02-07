import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  static bool go = false;
  static bool isGoogle = true;
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    LoginPage.isGoogle = true;
    LoginPage.go = true;

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> saveUserData(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'joinedGames': [],
    });

    print('User data saved to Firestore');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData && LoginPage.go) {
              saveUserData(snapshot.data as User);
              return HomePage();
            }
            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  const SizedBox(height: 80.0),
                  Column(
                    children: <Widget>[
                      Image.network("https://us.123rf.com/450wm/lar01joka/lar01joka1809/lar01joka180901398/109938255-%EA%B3%B5%EA%B3%B5-%EB%86%80%EC%9D%B4%ED%84%B0%EC%9D%98-%EC%A0%84%EB%A7%9D-%EB%B2%A1%ED%84%B0-%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8-%EB%A0%88%EC%9D%B4-%EC%85%98-%EB%94%94%EC%9E%90%EC%9D%B8.jpg?ver=6"),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                  const SizedBox(height: 120.0),
                  TextButton(
                    onPressed: signInWithGoogle,
                    child: Row(
                      children: [
                        Icon(Icons.g_mobiledata),
                        SizedBox(width: 30),
                        Text("GOOGLE"),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 217, 183, 255),
                    )
                  ),
                  const SizedBox(height: 12.0),
                ],
              ),
            );
          }),
    );
  }
}
