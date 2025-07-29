import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/auth/data/model/user_model.dart';

abstract class AuthDatasource {
  FutureVoid sendOTP(
    String phone,
    Function(String) onCodeSent,
    Function(String)? onAutoVerified,
  );
  FutureEither<AuthUserModel> verifyOTP(String verificationId, String otp);
  FutureEither<AuthUserModel?> getCurrentUser();
  FutureVoid signOut();
}
