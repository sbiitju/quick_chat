import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  TextButton(child: Text('Auth'),onPressed: (){
        FirebaseAuth.instance.signOut();
      },)),
      body:  Center(
        child: TextButton(
          onPressed: () {
          onGoogleSignInEvent().then((value) {
            print(value.user?.displayName);
          });
          },
          child: const Text('Go to Home'),
        )
      ),
    );
  }
}
Future<UserCredential> onGoogleSignInEvent() async {


  if(FirebaseAuth.instance.currentUser!= null){
    FirebaseAuth.instance.signOut();
  }
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
  await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );


  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

