import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventry_app/features/user/data/models/user_model.dart';

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

  User? get authUser => _auth.currentUser;

  Future<UserModel?> currentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _store.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          return UserModel.fromFirestore(data);
        }
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  //firestore
  Future<bool> storeDisplayname({required String name}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await _store.collection('users').doc(user.uid).set({
        'displayName': name,
      }, SetOptions(merge: true));
      return true;
    }
    return false;
  }

  DocumentReference<Map<String, dynamic>> getUserDoc({required String uid}) {
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  Future<void> storeUser({
    required String uid,
    required String displayName,
    required String phone,
    String? avatarUrl,
  }) async {
    return await _store.collection('users').doc(uid).set({
      'displayName': displayName,
      'phone': phone,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    }, SetOptions(merge: true));
  }
}
