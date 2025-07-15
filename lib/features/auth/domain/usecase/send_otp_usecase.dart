import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/usecase/usecase.dart';
import 'package:inventry_app/features/auth/domain/repo/auth_repo.dart';

class SendOtpUsecase extends UseCase<void,SendOTPParams>{
  final AuthRepository repo;

  SendOtpUsecase({required this.repo});

  @override
  Future<Either<Failure, void>> call(
    SendOTPParams param
  ) {
    return repo.sendOtp(param.phone, param.onCodeSent, param.onAutoVerified);
  }
}
