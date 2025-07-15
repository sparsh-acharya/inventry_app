import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/features/auth/data/datasource/datasource.dart';
import 'package:inventry_app/features/auth/data/model/user_model.dart';



class FirebaseAuthDatasource implements AuthDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, void>> sendOTP(
    String phone,
    Function(String verificationId) onCodeSent,
    Function(String uid)? onAutoVerified,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
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
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, UserModel>> verifyOTP(
      String verificationId, String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        return right(UserModel.fromFirebaseUser(user));
      } else {
        return left(FirebaseError(message: 'OTP verification failed: No user.'));
      }
    } catch (e) {
      return left(FirebaseError(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return right(UserModel.fromFirebaseUser(user));
      }
      return right(null);
    } on FirebaseException catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _auth.signOut();
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: _mapFirebaseError(e)));
    }
  }

  String _mapFirebaseError(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.message ?? 'FirebaseAuthException occurred';
    } else if (error is Exception) {
      return error.toString();
    } else {
      return 'An unknown error occurred';
    }
  }
}
