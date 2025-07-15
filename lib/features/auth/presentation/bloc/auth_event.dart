part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendOTPEvent extends AuthEvent {
  final String phoneNumber;

  const SendOTPEvent({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOTPEvent extends AuthEvent {
  final String verificationID;
  final String otp;

  const VerifyOTPEvent({required this.verificationID, required this.otp});

  @override
  List<Object> get props => [verificationID, otp];
}

class AutoVerifiedEvent extends AuthEvent {
  final String uid;

  const AutoVerifiedEvent(this.uid);

  @override
  List<Object> get props => [uid];
}


class GetCurrentUserEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent{}

class OtpSentEvent extends AuthEvent {
  final String verificationId;

  const OtpSentEvent(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}
