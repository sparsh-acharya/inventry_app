import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/firebase/firebase_functions.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/auth/data/datasource/datasource.dart';
import 'package:inventry_app/features/auth/data/model/user_model.dart';

class FirebaseAuthDatasource implements AuthDatasource {
  final FirebaseFunctions _fireFunc = FirebaseFunctions();

  @override
  FutureVoid sendOTP(
    String phone,
    Function(String verificationId) onCodeSent,
    Function(String uid)? onAutoVerified,
  ) async {
    try {
      await _fireFunc.sendOTP(
        phone: phone,
        onCodeSent: onCodeSent,
        timeout: const Duration(seconds: 60),
        onAutoVerified: onAutoVerified,
      );
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: _mapFirebaseError(e)));
    }
  }

  @override
  FutureEither<UserModel> verifyOTP(
    String verificationId,
    String otp,
  ) async {
    try {
      final credential = _fireFunc.verifyOTP(
        verificationId: verificationId,
        otp: otp,
      );

      final userCredential = await _fireFunc.signIn(credential: credential);

      final user = userCredential.user;

      if (user != null) {
        return right(UserModel.fromFirebaseUser(user));
      } else {
        return left(
          FirebaseError(message: 'OTP verification failed: No user.'),
        );
      }
    } catch (e) {
      return left(FirebaseError(message: _mapFirebaseError(e)));
    }
  }

  @override
  FutureEither<UserModel?> getCurrentUser() async {
    try {
      final user = await _fireFunc.currentUser();
      if (user != null) {
        return Right(user as UserModel?);
      } else {
        return Left(FirebaseError(message: 'User not Logged In'));
      }
    } on FirebaseException catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid signOut() async {
    try {
      await _fireFunc.signOut();
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
