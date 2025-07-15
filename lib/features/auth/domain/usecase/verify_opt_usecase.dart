import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/usecase/usecase.dart';
import 'package:inventry_app/features/auth/domain/entity/user_entity.dart';
import 'package:inventry_app/features/auth/domain/repo/auth_repo.dart';

class VerifyOptUsecase extends UseCase<UserEntity,VerifyOTPParam> {
  final AuthRepository repo;

  VerifyOptUsecase({required this.repo});

  @override
  Future<Either<Failure, UserEntity>> call(VerifyOTPParam param) {
    return repo.verifyOtp(param.verificationId, param.otp);
  }
}
