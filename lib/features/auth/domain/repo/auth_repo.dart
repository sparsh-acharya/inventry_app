import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendOtp(
    String phone,
    Function(String verificationId) onCodeSent,
    Function(String uid)? onAutoVerified,
  );

  Future<Either<Failure, UserEntity>> verifyOtp(String verificationId, String otp);

  Future<Either<Failure,UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> signOut();
}
