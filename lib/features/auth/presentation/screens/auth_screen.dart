import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_chat/core/routes/routes.dart';
import 'package:quick_chat/features/auth/providers/auth_providers.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    //TODO:SHow loading
    //TODO: Toast message

    ref.listen(authProvider, (_, state) {
      //TODO Error handling
      if (state?.emailVerified == true) {
        context.goNamed(Routes.home);
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Let's get started!"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).signInWithGoogle();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Continue with Google'),
                  const SizedBox(width: 10),
                  SvgPicture.asset('assets/svg/ic_google.svg',
                      width: 24, height: 24)
                ],
              ),
            ),
            // TextButton(
            //   onPressed: () async {
            //     final state = FirebaseAuth.instance.currentUser;
            //     try{
            //       await FirebaseFirestore.instance.collection('users').doc(state?.uid).set({
            //         'displayName': state?.displayName,
            //         'email': state?.email,
            //         'photoURL': state?.photoURL, // You can set the profile photo URL here
            //       });
            //     }catch(e){
            //       print('Error: $e');
            //     }
            //   },
            //   child: const Text('Add Data'),
            // ),
          ],
        ),
      ),
    );
  }
}

Future<UserCredential> onGoogleSignInEvent() async {
  if (FirebaseAuth.instance.currentUser != null) {
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
