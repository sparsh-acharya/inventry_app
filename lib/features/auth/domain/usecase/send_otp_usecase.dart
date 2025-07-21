import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/auth/domain/repo/auth_repo.dart';

class SendOtpUsecase extends UseCase<void,SendOTPParams>{
  final AuthRepository repo;

  SendOtpUsecase({required this.repo});

  @override
  FutureVoid call(
    SendOTPParams param
  ) {
    return repo.sendOtp(param.phone, param.onCodeSent, param.onAutoVerified);
  }
}
