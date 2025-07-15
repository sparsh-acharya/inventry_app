import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

class SendOTPParams {
  final String phone;
  final Function(String verificationId) onCodeSent;
  final Function(String uid)? onAutoVerified;

  SendOTPParams({
    required this.phone,
    required this.onCodeSent,
    this.onAutoVerified,
  });
}

class VerifyOTPParam {
  final String verificationId;
  final String otp;

  VerifyOTPParam({required this.verificationId, required this.otp});
}
