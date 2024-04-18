import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fireStoreProvider = Provider<FirebaseFirestore>((ref) {
  Firebase.initializeApp();
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  Firebase.initializeApp();
  return FirebaseAuth.instance;
});