import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
 FutureVoid sendOtp(
    String phone,
    Function(String verificationId) onCodeSent,
    Function(String uid)? onAutoVerified,
  );

  FutureEither<UserEntity> verifyOtp(String verificationId, String otp);

  FutureEither<UserEntity?> getCurrentUser();

  FutureVoid signOut();
}
