import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/auth/data/datasource/datasource.dart';
import 'package:inventry_app/features/auth/domain/entity/user_entity.dart';
import 'package:inventry_app/features/auth/domain/repo/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  FutureVoid sendOtp(
    String phone,
    Function(String verificationId) onCodeSent,
    Function(String uid)? onAutoVerified,
  ) async {
    final result = await datasource.sendOTP(phone, onCodeSent, onAutoVerified);
    return result.fold((failure) => left(failure), (_) => right(null));
  }

  @override
  FutureEither<UserEntity> verifyOtp(
    String verificationId,
    String otp,
  ) async {
    final result = await datasource.verifyOTP(verificationId, otp);

    return result.fold(
      (failure) => left(failure),
      (userModel) => right(userModel),
    );
  }

  @override
  FutureEither<UserEntity?> getCurrentUser() {
    return datasource.getCurrentUser();
  }

  @override
  FutureVoid signOut() async {
    final result = await datasource.signOut();
    return result.fold((failure) => left(failure), (_) => right(null));
  }
}
