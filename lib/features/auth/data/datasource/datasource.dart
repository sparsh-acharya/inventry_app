import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/features/auth/data/model/user_model.dart';

abstract class AuthDatasource {
  Future<Either<Failure,void>> sendOTP(
    String phone,
    Function(String) onCodeSent,
    Function(String)? onAutoVerified,
  );
  Future<Either<Failure,UserModel>> verifyOTP(String verificationId, String otp);
  Future<Either<Failure, UserModel?>> getCurrentUser();
  Future<Either<Failure,void>> signOut();
}
