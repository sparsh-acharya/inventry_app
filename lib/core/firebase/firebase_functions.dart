import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  //auth
  Future<void> sendOTP({
    required String phone,
    required Function(String verificationId) onCodeSent,
    Function(String uid)? onAutoVerified,
    required Duration timeout,
  }) async {
    return await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: timeout,
      verificationCompleted: (PhoneAuthCredential credential) async {
        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          onAutoVerified?.call(user.uid);
        } else {
          throw FirebaseAuthException(
            code: 'user-null',
            message: 'Auto verification failed: No user found.',
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  PhoneAuthCredential verifyOTP({
    required String verificationId,
    required String otp,
  }) {
    return PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
  }

  Future<UserCredential> signIn({
    required PhoneAuthCredential credential,
  }) async {
    return await _auth.signInWithCredential(credential);
  }

  User? currentUser() {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  //firestore
  Future<void> storeDisplayname({
    required String uid,
    required String name,
  }) async {
    return await _store.collection('users').doc(uid).set({
      'displayName': name,
    }, SetOptions(merge: true));
  }

  DocumentReference<Map<String, dynamic>> getUserDoc({required String uid}) {
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  Future<void> storeUser({
    required String uid,
    required String displayName,
    required String phone,
  }) async {
    return await _store.collection('users').doc(uid).set({
      'displayName': displayName,
      'phone': phone,
    }, SetOptions(merge: true));
  }
}
